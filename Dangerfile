# By Jakub Kaspar 10/30/2018
# STRV s.r.o. 2018
# STRV

# Sometimes its a README fix, or something like that - which isn't relevant for including in a CHANGELOG for example
declared_trivial = github.pr_title.include?("#trivial") || github.pr_title.include?("[WIP]") || github.pr_body.include?("#trivial")

# Uncomment following lines if you want to enforce CHANGELOG updates
# if git.lines_of_code > 50 && !git.modified_files.include?("CHANGELOG.md") && !git.added_files.include?("CHANGELOG.md") && !declared_trivial
#     fail("No CHANGELOG changes made")
# end

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

# Mainly to encourage writing up some reasoning about the PR, rather than just leaving a title
if github.pr_body.length < 5
    fail("Please provide a summary in the Pull Request description")
end

# Warn when there is a big PR
if git.lines_of_code > 1000
    warn("Big PR - you should create smaller!")
end

swiftlint.config_file = '.swiftlint.yml'
swiftlint.binary_path = 'Pods/SwiftLint/swiftlint'
swiftlint.lint_files inline_mode:true, fail_on_error:true

duplicate_localizable_strings.check_localizable_duplicates
