---
name: Maintainers Only - Release
about: Release checklist.
title: "[MAINTAINER] [RELEASE]"
labels: maintainer, release
assignees: a-mabe

---

⚠️ **This issue template is for maintainers only. Please do not use it unless you are a maintainer of this project.** ⚠️

# Release Checklist

## 1. Merge and Prepare for Release
- [ ] Verify CI tests pass.
- [ ] Merge feature branch(es) into `main`.
- [ ] Confirm `pubspec.yaml` version is updated.

## 2. Create a Beta Pre-Release
- [ ] Tag pre-release as `X.Y.Z-beta`.
- [ ] Workflow runs to generate pre-release.
- [ ] Ensure pre-release workflow has created a GitHub Issue for the release titled `X.Y.Z-beta`.
- [ ] Ensure pre-release artifacts are built and attached to the release.
- [ ] Manually upload to Google Play Open Testing & TestFlight.
    - [ ] Take new screenshots as needed.
    - [ ] Create "What's Changed" text:
        - <put here>
- [ ] Workflow manually triggered to open discussion post to advertise the beta release for open testing.

## 3. Beta Testing Phase
- [ ] Collect feedback and crash reports.
- [ ] If needed, create `X.Y.Z-beta2`.
    - [ ] Manually update the original discussion post as needed for new versions of the beta release.

### Beta Testing Timeline

#### Patch Releases
1. [ ] Changes will be QA tested after being accepted by Google/Apple (likely 24 hours, up to 7 days).
2. [ ] After QA testing, the release will be promoted from beta testing to production.

#### Major and Minor Releases
1. [ ] Changes will be QA tested after being accepted by Google/Apple (likely 24 hours, up to 7 days).
2. [ ] After QA testing, the release will remain available in open testing for 7 - 10 days to recieve user feedback.
2. [ ] After the open testing period, the release will be promoted from beta testing to production.

## 4. Promote to Stable Release
- [ ] Run the **"Promote Beta to Stable Release"** GitHub Action.
- [ ] Confirm `vX.Y.Z` release is created with the same artifacts.
- [ ] Manually submit stable release to app stores.

## 5. Post-Release Tasks
- [ ] Trigger workflow to annouce the release.
- [ ] Monitor analytics and feedback.
- [ ] Start planning the next release.
