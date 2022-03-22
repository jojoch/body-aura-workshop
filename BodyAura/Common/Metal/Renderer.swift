//
//  Renderer.swift
//  BodyAura
//
//  Created by Veronika Zelinkova on 09.06.2021.
//  Copyright © 2021 STRV. All rights reserved.
//

import ARKit
import Metal
import MetalKit
import MetalPerformanceShaders

protocol RenderDestinationProvider {
    var currentRenderPassDescriptor: MTLRenderPassDescriptor? { get }
    var currentDrawable: CAMetalDrawable? { get }
    var colorPixelFormat: MTLPixelFormat { get set }
    var sampleCount: Int { get set }
}

// The max number of command buffers in flight
let kMaxBuffersInFlight: Int = 3

// Vertex data for an image plane
let kImagePlaneVertexData: [Float] = [
    -1.0, -1.0, 0.0, 1.0,
    1.0, -1.0, 1.0, 1.0,
    -1.0, 1.0, 0.0, 0.0,
    1.0, 1.0, 1.0, 0.0
]

// swiftlint:disable all implicitly_unwrapped_optional
class Renderer {
    // MARK: - Private Properties
    
    private let session: ARSession
    private let device: MTLDevice
    private let inFlightSemaphore = DispatchSemaphore(value: kMaxBuffersInFlight)
    private var renderDestination: RenderDestinationProvider
    // TODO: 1 - Add ARMatteGenerator property

    private var commandQueue: MTLCommandQueue!
    private var imagePlaneVertexBuffer: MTLBuffer!
    private var imagePipelineState: MTLRenderPipelineState!

    private var capturedImageTextureY: CVMetalTexture?
    private var capturedImageTextureCbCr: CVMetalTexture?
    private var capturedImageTextureCache: CVMetalTextureCache!
    // TODO: 1 - Add matteTexture property
    // TODO: 2 - Add matteBlurredTexture property

    private var viewportSize = CGSize()
    private var viewportSizeDidChange: Bool = false
    
    // MARK: - Constants
    // TODO: 2 - Add auraIntensity property
    // TODO: 5 - Add gamma property
    // TODO: 5 - Add previousColor property
    
    // MARK: - Public Properties
    // TODO: 3 - Add auraColor property
    
    // MARK: - Public Methods

    init(session: ARSession, metalDevice device: MTLDevice, renderDestination: RenderDestinationProvider) {
        self.session = session
        self.device = device
        self.renderDestination = renderDestination
        
        // TODO: 1 - Initialize ARMatteGenerator

        loadMetal()
    }

    func drawRectResized(size: CGSize) {
        viewportSize = size
        viewportSizeDidChange = true
    }

    func update() {
        _ = inFlightSemaphore.wait(timeout: DispatchTime.distantFuture)

        if let commandBuffer = commandQueue.makeCommandBuffer() {
            var textures = [capturedImageTextureY, capturedImageTextureCbCr]
            commandBuffer.addCompletedHandler { [weak self] _ in
                if let strongSelf = self {
                    strongSelf.inFlightSemaphore.signal()
                }
                textures.removeAll()
            }

            updateGameState()
            // TODO: 1 - call updateMatteTexture(:)
            // TODO: 2 - call blendMatteTexture(:)

            if let renderPassDescriptor = renderDestination.currentRenderPassDescriptor,
               let currentDrawable = renderDestination.currentDrawable {
                if let sceneRenderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) {
                    drawFinalImage(renderEncoder: sceneRenderEncoder)

                    sceneRenderEncoder.endEncoding()
                }
                
                commandBuffer.present(currentDrawable)
            }
            
            commandBuffer.commit()
        }
    }
}

// MARK: - Initialization

private extension Renderer {
    func loadMetal() {
        renderDestination.colorPixelFormat = .bgra8Unorm
        renderDestination.sampleCount = 1
        
        let imagePlaneVertexDataCount = kImagePlaneVertexData.count * MemoryLayout<Float>.size
        imagePlaneVertexBuffer = device.makeBuffer(bytes: kImagePlaneVertexData, length: imagePlaneVertexDataCount, options: [])
        
        let imagePlaneVertexDescriptor = MTLVertexDescriptor()
        
        imagePlaneVertexDescriptor.attributes[0].format = .float2
        imagePlaneVertexDescriptor.attributes[0].offset = 0
        imagePlaneVertexDescriptor.attributes[0].bufferIndex = Int(kBufferIndexMeshPositions.rawValue)
        
        imagePlaneVertexDescriptor.attributes[1].format = .float2
        imagePlaneVertexDescriptor.attributes[1].offset = 8
        imagePlaneVertexDescriptor.attributes[1].bufferIndex = Int(kBufferIndexMeshPositions.rawValue)
        
        imagePlaneVertexDescriptor.layouts[0].stride = 16
        imagePlaneVertexDescriptor.layouts[0].stepRate = 1
        imagePlaneVertexDescriptor.layouts[0].stepFunction = .perVertex


        guard let defaultLibrary = device.makeDefaultLibrary() else {
            fatalError("Failed to create default library")
        }

        var textureCache: CVMetalTextureCache?
        CVMetalTextureCacheCreate(nil, nil, device, nil, &textureCache)
        capturedImageTextureCache = textureCache
        
        let imagePipelineStateDescriptor = MTLRenderPipelineDescriptor()
        imagePipelineStateDescriptor.sampleCount = renderDestination.sampleCount
        imagePipelineStateDescriptor.vertexFunction = defaultLibrary.makeFunction(name: "capturedImageVertexTransform")!
        imagePipelineStateDescriptor.vertexDescriptor = imagePlaneVertexDescriptor
        imagePipelineStateDescriptor.fragmentFunction = defaultLibrary.makeFunction(name: "capturedImageFragmentShader")!
        imagePipelineStateDescriptor.colorAttachments[0].pixelFormat = renderDestination.colorPixelFormat
        
        do {
            try imagePipelineState = device.makeRenderPipelineState(descriptor: imagePipelineStateDescriptor)
        } catch {
            fatalError("Failed to create composite image pipeline state, error \(error)")
        }

        commandQueue = device.makeCommandQueue()
    }
}

// MARK: - Private Methods

private extension Renderer {
    func updateCapturedImageTextures(frame: ARFrame) {
        let pixelBuffer = frame.capturedImage

        if CVPixelBufferGetPlaneCount(pixelBuffer) < 2 {
            return
        }

        capturedImageTextureY = createTexture(fromPixelBuffer: pixelBuffer, pixelFormat: .r8Unorm, planeIndex: 0)
        capturedImageTextureCbCr = createTexture(fromPixelBuffer: pixelBuffer, pixelFormat: .rg8Unorm, planeIndex: 1)
    }

    func createTexture(fromPixelBuffer pixelBuffer: CVPixelBuffer, pixelFormat: MTLPixelFormat, planeIndex: Int) -> CVMetalTexture? {
        let width = CVPixelBufferGetWidthOfPlane(pixelBuffer, planeIndex)
        let height = CVPixelBufferGetHeightOfPlane(pixelBuffer, planeIndex)

        var texture: CVMetalTexture?
        let status = CVMetalTextureCacheCreateTextureFromImage(
            nil,
            capturedImageTextureCache,
            pixelBuffer,
            nil,
            pixelFormat,
            width,
            height,
            planeIndex,
            &texture
        )
        
        guard status == kCVReturnSuccess else {
            return nil
        }

        return texture
    }
    
    func updateGameState() {
        guard let currentFrame = session.currentFrame else {
            return
        }

        updateCapturedImageTextures(frame: currentFrame)

        if viewportSizeDidChange {
            viewportSizeDidChange = false
            
            let displayToCameraTransform = currentFrame.displayTransform(for: .portrait, viewportSize: viewportSize).inverted()
        
            let vertexData = imagePlaneVertexBuffer.contents().assumingMemoryBound(to: Float.self)
            for index in 0...3 {
                let textureCoordIndex = 4 * index + 2
                let textureCoord = CGPoint(x: CGFloat(kImagePlaneVertexData[textureCoordIndex]), y: CGFloat(kImagePlaneVertexData[textureCoordIndex + 1]))
                let transformedCoord = textureCoord.applying(displayToCameraTransform)
                
                vertexData[textureCoordIndex] = Float(transformedCoord.x)
                vertexData[textureCoordIndex + 1] = Float(transformedCoord.y)
            }
        }
    }
    
    func updateMatteTexture(commandBuffer: MTLCommandBuffer) {
        // TODO: 1 - implementation
    }
    
    func blendMatteTexture(commandBuffer: MTLCommandBuffer) {
        /*guard let matteTexture = matteTexture else {
            return
        }
            
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: matteTexture.pixelFormat,
            width: matteTexture.width,
            height: matteTexture.height,
            mipmapped: false
        )
        descriptor.usage = [.shaderWrite, .shaderRead]
                
        matteBlurredTexture = device.makeTexture(descriptor: descriptor)*/
            
        // TODO: 2 - Blur matteTexture using MPSImageTent
    }
    
    func drawFinalImage(renderEncoder: MTLRenderCommandEncoder) {
        guard let textureY = capturedImageTextureY, let textureCbCr = capturedImageTextureCbCr else {
            return
        }
        
        // TODO: 5 - smooth auraColor change
        
        renderEncoder.setRenderPipelineState(imagePipelineState)
        renderEncoder.setVertexBuffer(imagePlaneVertexBuffer, offset: 0, index: 0)
        renderEncoder.setFragmentTexture(CVMetalTextureGetTexture(textureY), index: Int(kTextureIndexY.rawValue))
        renderEncoder.setFragmentTexture(CVMetalTextureGetTexture(textureCbCr), index: Int(kTextureIndexCbCr.rawValue))
        // TODO: 1 - send matteTexture to GPU
        // TODO: 2 - send matteBlurredTexture to GPU
        // TODO: 3 - send auraColor to GPU
        
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
    }
}
