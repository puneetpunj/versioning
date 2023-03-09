## Introduction
### What is software versioning?
With software versioning we try to come up with a way to uniquely identify our different phases of our software that we have delivered. When talking about a specific versioning, we use this number or text as a reference to our software in given time.

### Different Versioning Schemes
In the scope of versioning an application, there are couple of different schemes that can be chosen. This depends on what the chosen Continuous Integration software would support.

Common versioning schemes that teams choose are:

- Build numbers: where an incremental number is used that is defined by the run of an automatic build pipeline (currently implemented, docker images are published with CI-<build_number> 
- Date and time: where the timestamp of a build is used as an unique timestamp to define a version
- Semantic version: shortened SemVer, where on the basis of creating major.minor.patch+<additional_attributes>  scheme a version is defined
There is a main disadvantage with the first two schemes; they aren’t descriptive. When comparing multiple versions that follow an incremented version, it’s hard to understand for a user if non breaking changes has been introduced in a new version. The intention of the new version can’t be deduced of the version number alone.

### SemVer
Semantic versioning offers a solution to be more descriptive in the version numbers. A semantic version number follows the structure MAJOR.MINOR.PATCH.

The different sections are numbers. We increment:

- the MAJOR part when we introduce incompatible/API breaking changes,
- the MINOR part when we add functionality in a backwards compatible manner, and
- the PATCH part when we make backwards compatible bug fixes.

The semantic version strategy became the industry standard to version applications.

Automate Semantic Versioning
With the help of GitVersion, using git branches and CI/CD pipelines, integration of automatic version number generation is possible.

## GitVersion

[GitVersion](https://gitversion.net/) is a Command Line Interface, shortened CLI, to generate these version numbers. GitVersion works well with existing Git branching strategies like Mainline, GitFlow or GitHub Flow. Although using a standardised branching strategy is recommended, with GitVersion’s flexible configuration the tool can be set up according to fulfil the desired needs.

#### Versioning Strategy 
- Following Continuous Delivery approach. 
- Assuming main branch is protected and can only be committed via PR process
- Every PR merge commit to main will increment minor version
- Any hotfix branch will increment patch version
- commit message with `major:` will be used to increment major version
- create initial tag `1.0.0` manually otherwise GitVersion default version 'll start from `0.1.0`
- This strategy will ensure every branch has unique version and can be published independently.

### User Workflow

| User Action  | Major   | Minor  | Patch  | Suffix|
| :------------| :------:| :-----:| :-----:| :-----:|
| Main Branch  | 1       | 0      |0       |       |
| Create new feature branch feature/<feature_name>   |        |       |       |       |
| Create a PR and publish new feature image  | 1       | 0      |0       |<feature_name>-ci-<build_number>-<commit_sha>        |
| Merge with Main  | 1       | 1      |0       |       |
| Create git tag with current version (1.1.0)  |        |      |       |       |
| Create new feature branch feature/<feature_name>   |        |       |       |       |
| Create a PR and publish new feature image  | 1       | 1      |0       |  	<feature_name>-ci-<build_number>-<commit_sha>      |
| Merge with Main  | 1       | 2      |0       |       |
| Create git tag with current version (1.2.0) |        |       |       |       |