# Release Process Documentation

## Overview

This document outlines the complete release process for OpenHIIT. The process is designed to minimize bugs and other issues.

### Release Timeline Summary

**Note: It can take anywhere from 1 to 7 days for a beta release to be accepted by the Play Store or App Store for open testing.**

| Release Type | Beta Duration | Total Timeline |
|-------------|---------------|----------------|
| Patch (X.Y.Z) | 1-3 days from open testing release | ~2-10 days total |
| Minor (X.Y.0) | 3-7 days from open testing release | ~4-14 days total |
| Major (X.0.0) | 7-14 days from open testing release | ~8-21 days total |

---

## Phase 1: Prepare

:warning: **Create a GitHub issue for this release using the Release Checklist template.**

Create the release branch `release/X.Y.Z`. The release branch serves as a stable environment for final testing and beta distribution, isolating the release from ongoing development work on the main branch.

### Steps

1. **Verify all CI tests pass on `main`**
   - Ensure all automated tests are passing before creating the release branch

2. **Create release branch `release/X.Y.Z` from `main`**
   - Branch name format: `release/1.2.3`

3. **Confirm `pubspec.yaml` version is updated to `X.Y.Z` on the release branch**

4. **Open PR from `release/X.Y.Z` to `main` for final review**
   - This PR serves as a review checkpoint before beta creation

### Key Considerations

- The release branch isolates stabilization work from ongoing feature development
- All beta testing and fixes will occur on this branch
- New features should not be added to the release branch after creation

---

## Phase 2: Create Beta Pre-Release

The beta release is distributed to open testing participants for validation before the stable release. The beta release will also be QA tested by the maintainer.

### Steps

1. **Create tag `X.Y.Z-beta` (pre-release) from `release/X.Y.Z` branch**
   - Creating the tag automatically triggers the build workflow
   - The workflow creates the GitHub Release automatically

2. **Workflow runs to build artifacts and attach to the beta release**
   - Automated build creates APK/AAB/IPA files
   - Artifacts are automatically attached to the GitHub Release

3. **Manually upload artifacts to Google Play Open Testing & TestFlight**
   - This step requires manual intervention (for now)

### Automation

The beta workflow automatically:

- Builds release artifacts (APK, AAB, IPA)
- Creates the GitHub Release
- Attaches build artifacts to the release
- Opens a GitHub Discussion post to advertise the beta

---

## Phase 3: Beta Testing Phase

Beta testing allows us to validate the release in real-world conditions and gather feedback before promoting to production.

### Testing Process

- Collect feedback and crash reports via GitHub Issue and discussion
- Monitor app store crash analytics and user feedback
- Maintainer QA tests to validate all major features and bug fixes

### If Fixes Are Needed

1. **Commit fixes to `release/X.Y.Z` branch**
2. **Create `X.Y.Z-beta2` release**
   - Update suggested full release date if the timeline needs adjustment
3. **Workflow automatically updates the original discussion post with the new beta version**

### Beta Testing Timeline

#### Patch Releases

**Suggested Full Release Date:** 1-3 day(s) from app store acceptance

1. QA testing after app store acceptance (24 hours - 7 days from submission date)
2. Upon QA approval, promote to stable release

#### Minor Releases

**Suggested Full Release Date:** 3-7 days from initial beta

1. QA testing after app store acceptance (24 hours - 7 days from submission date)
2. Open testing period for a few days for user feedback
   - Extended testing allows external users to validate new features
3. Upon successful testing period, promote to stable release

#### Major Releases

**Suggested Full Release Date:** 7-14 days from initial beta

1. QA testing after app store acceptance (24 hours - 7 days from submission date)
2. Open testing period for a few days for user feedback
   - Extended testing allows external users to validate new features
3. Upon successful testing period, promote to stable release

---

## Phase 4: Promote to Stable Release

After successful beta testing, the release is promoted to stable and distributed to all users via production app stores.

### Steps

1. **Create tag `X.Y.Z` (stable) from `release/X.Y.Z` branch**
   - This tag points to the exact code that was tested in beta

2. **Workflow triggered by tag to promote the latest beta release to stable**
   - The same artifacts from beta are reused (no rebuild needed)
   - This ensures binary equivalence between beta and stable

3. **Merge `release/X.Y.Z` branch to `main` via PR**
   - All release changes and fixes are now in the main branch

4. **Manually promote beta to production in Google Play & App Store Connect**
   - Google Play: Promote from Open Testing to Production
   - App Store Connect: Submit the TestFlight build for App Store review

### Important Notes

- The stable tag (`X.Y.Z`) is created on the release branch, not on `main`
- This ensures the tag points exactly to what was tested, even if other work was merged to main during beta testing
- After merging to main, the release branch can be safely deleted (the tags remain in git history)

---

## Phase 5: Post-Release Tasks

After the stable release is live, monitor performance and prepare for the next release cycle.

### Cleanup Tasks

- Close the release GitHub Issue
- Archive the release discussion
- Delete `release/X.Y.Z` branch (tags remain in git history)
  - This keeps the repository clean while preserving release history

### Monitoring

- Monitor analytics for adoption rates and user behavior changes
- Track crash reports and error rates in production
- Review user feedback and app store reviews
- Identify any critical issues requiring a hotfix

### Planning

- Plan next release and update roadmap
- Prioritize issues and features for the next cycle
- Update project documentation based on lessons learned

---

## Notes on Best Practices

### Branch Management

- Never commit directly to `main` - always use pull requests
- Keep the release branch focused on stabilization - no new features
- If a critical fix is needed during beta, apply it to the `release/X.Y.Z` branch first
- After merging the release branch to `main`, the fix will automatically be included in future releases

### Version Numbering

Follow semantic versioning (MAJOR.MINOR.PATCH):

- **MAJOR**: Breaking changes or major new features
- **MINOR**: New features, no breaking changes
- **PATCH**: Bug fixes, minor chores

### Communication

- Use the GitHub Discussion for beta announcements and user feedback
- Keep the release issue updated with progress and blockers
- Provide clear release notes highlighting user-facing changes and internal improvements
- Document breaking changes prominently with migration steps

### Quality Assurance

- Never skip the beta phase, even for small patches
- Allow sufficient time for app store review (can take 24 hours to 7 days)
- For major releases, consider extending the beta period to gather more feedback
- Always test on both iOS and Android platforms before promotion
