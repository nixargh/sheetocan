# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [3.5.1] - 2020-03-02
### Fixed
- `sheetocan` do not try to make backup of timesheet file if it's not exists.

## [3.5.0] - 2020-01-08
### Added
- `calendar.yaml` work hours for year **2020**.

## [3.4.1] - 2019-09-24
### Fixed
- **README** *ruby-dev* has been added to deb dependencies.
- Ignore **Gemfile.lock**.

## [3.4.0] - 2019-05-06
### Changed
- **Jira** skip *Keyring* operations if library load fails.
- **README** installation part.

### Removed
- **gir_ffi-gnome_keyring** gem from *Gemfile*.

## [3.3.0] - 2019-03-16
### Added
- **Jira#get** downloads into tmp file first, make backup of previous version and then move. 

## [3.2.0] - 2019-03-13
### Added
- Keyring support.
- `--login` option. LDAP login.
- `--password` option. LDAP password.
- `--footer` option. It's path to a text file with anything you like. Its content will be added in the end of timesheet.

## [3.1.0] - 2019-02-28
### Added
- Transformation on **get** to *old school* format (with quotes and blank lines).
- Jira API **errorMessage** output.

### Change
- `TimeSheet#read` the way it works a litle.

## [3.0.2] - 2019-02-23
### Fixed
- A few typos.

### Added
- `Gemfile`.

### Changed
- Git installation instruction.

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
