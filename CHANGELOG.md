# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [3.0.1] - 2019-02-23
### Fixed
- `README.md` exports.

## [3.0.0] - 2019-02-23
### Added
- Catch some errors.
- `--version` option. Just shows the version.
- `--get` option. Gets timesheet text from Jira.
- `--put` option. Puts timesheet text to Jira.

## [2.5.0] - 2018-12-30
### Added
- `calendar.yaml` work hours for year 2019.

## [2.4.2] - 2018-08-22
### Fixed
- Jira tickets' names for projects with numbers in their name.

## [2.4.1] - 2018-07-02
### Fixed
- Jira tickets' names.

## [2.4.0] - 2018-04-02
### Added
- `--vacation` option. It allows to adjust number of working hours based on IOW rules.

## [2.3.1] - 2018-03-01
### Fixed
- #11: `Error: undefined method `delete' if the timesheet has invalid record` https://github.com/nixargh/sheetocan/issues/11

## [2.3.0] - 2018-02-27
### Added
- Support of Jira tracker.

### Changed
- `RT:` string removed from tickets names in teamlead report.
