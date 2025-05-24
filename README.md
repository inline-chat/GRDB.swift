# GRDB + SQLCipher

## What is this?

This is a fork of [GRDB](https://github.com/groue/GRDB.swift) with added support for [SQLCipher Community Edition](https://www.zetetic.net/sqlcipher/open-source/), packaged into XCFramework so that it can be consumed as a Swift Package, for Inline, initially made by DuckDuckGo.

The default branch for this repository is `main` (as opposed to upstream's `master`) and it doesn't include GRDB (or SQLCipher) source code – only the Swift Package definition and release scripts/assets. XCFramework archives are attached directly in [GitHub Releases](https://github.com/inline-chat/GRDB.swift/releases).

## Version

* This Package: *3.2.0*
* GRDB: *7.5.0*
* SQLCipher: *4.9.0*

## Contributions

We do not accept contributions to this repository at this time. However, feel free to open an issue in order to start a discussion.

## Thanks to DuckDuckGo

DuckDuckGo has made the initial version of this package possible.

## Updating from Upstream

The update process is semi-automatic, i.e. it uses a shell script that guides you through, but the script requires user input and must be run locally.

Run `prepare_release.sh`, which:

- Creates a temporary directory.
- Clones upstream GRDB.swift into a subdirectory.
- Clones SQLCipher into another subdirectory.
- Checks out the latest tags of upstream GRDB.swift and SQLCipher.
- Compares tags with versions included in the current release (based on the content of this README file).
  - If versions didn't change, the script stops here.
  - If there are updates, the script asks you to input the new version (see [Versioning](#versioning)). The script then generates an updated README.md with udpated versions.
- Builds SQLCipher and moves sqlite3.c/h to GRDB.swift project.
- Patches GRDB to include SQLCipher sources.
  - If patching fails, the script stops and asks you to patch the project yourself. Once done, it stores the patch for later use.
- Builds GRDB and runs unit tests.
- Builds frameworks for iOS, iOS Simulator and macOS and creates XCFramework.
- Updates Package.swift with the new version and new XCFramework checksum.
- Commits changes, tags the commit, pushes to origin and creates GitHub release.

Once the script is done:

- create PR for BSK referencing the new GRDB.swift version,
- create PRs for iOS and macOS apps referencing your BSK branch.

### Versioning

For versioning, follow [Semantic Versioning Rules](https://semver.org), but note you don't need
to use the same version as GRDB. Examples:

- Upstream GRDB 5.6.0, after merge -> 5.12.0

  - This project 1.0.0 -> 1.1.0

- Upstream GRDB 5.12.0, after merge -> 6.0.0
  - This project 1.1.0 -> 2.0.0

### Compiling SQLCipher manually

In case `prepare_release.sh` script fails, you need to compile SQLCipher amalgamation package
manually. See [general instructions](https://github.com/sqlcipher/sqlcipher#compiling-for-unix-like-systems):

- Use `./configure --with-crypto-lib=none`.
- Remember to use `make sqlite3.c` and not `make`.
- Copy `sqlite3.c` and `sqlite3.h` to `Sources/SQLCipher/sqlite3.c` and `Sources/SQLCipher/include/sqlite3.h`.
