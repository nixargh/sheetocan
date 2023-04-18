# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [3.12.0] - 2023-04-18
### Changed
- `sheetocan` Jira API address.

## [3.11.1] - 2023-03-20
### Fixed
- `calendar.yaml` for 3-rd month of 2023.

## [3.11.0] - 2023-01-09
### Changed
- `calendar.yaml` working hours for the first half of year **2023**. Probably the last release ever.

## [3.10.0] - 2022-03-21
### Changed
- `sheetocan` support new IOW calendar with monthes division at 21-t day.
- `calendar.yaml` covert year **2022** working hours to new IOW calendar.

### Added
- `sheetocan` new command line option **--day** to set day of a month for a report.

## [3.9.0] - 2022-01-04
### Changed
- `calendar.yaml` working hours for **2022**.

## [3.8.0] - 2021-07-02
### Added
- `sheetocan` new command line argument **--ignore_badlines**. Allows to get report even after parsing errors.

## [3.7.0] - 2020-12-25
### Changed
- `calendar.yaml` working hours for **2021**, adjust of December 2020.

## [3.6.0] - 2020-08-11
### Fixed
- `sheetocan` linted.

### Changed
- `sheetocan` adjust *vacation coefficient* from **6** to **5.714**.

## [3.5.4] - 2020-06-22
### Fixed
- `calendar` reduce working hours for July due to additional national holiday.

## [3.5.3] - 2020-04-07
### Fixed
- `calendar` increase working hours for April back to default.

## [3.5.2] - 2020-03-26
### Fixed
- `calendar` reduce working hours for March and April due to COVID-19 pandemia.

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
