Execute a full release of the EasyDiet Flutter app. Follow these steps IN ORDER, stopping on any error:

## Step 1: Pre-flight checks

1. Run `flutter analyze` - abort if any errors
2. Run `git status` - warn if there are untracked files that look important
3. Read `pubspec.yaml` to get the CURRENT version (format: `X.Y.Z+N`)

## Step 2: Version bump

1. Ask the user what type of release this is:
   - **patch** (bug fixes) -> bump Z
   - **minor** (new features) -> bump Y, reset Z
   - **major** (breaking changes) -> bump X, reset Y and Z
2. Always increment N (the build number / versionCode) by 1
3. Update `pubspec.yaml` with the new version
4. IMPORTANT: The versionCode (N) MUST be strictly greater than the previous one for the Play Store

## Step 3: Generate changelog

1. Run `git log --oneline` since the last tag (or last 20 commits if no tag) to see what changed
2. Read AUDIT.md to see recently completed items
3. Write a changelog in French with two formats:

**GitHub Release notes** (Markdown, detailed):
```
## Nouveautes
- ...

## Corrections
- ...

## Ameliorations techniques
- ...
```

**Play Store changelog** (plain text, max 500 chars, user-facing only):
```
Nouveautes :
- ...

Corrections :
- ...
```

4. Show both to the user for approval before proceeding

## Step 4: Commit & push

1. Stage all modified files with `git add` (be specific, no `git add -A`)
2. Create a commit with message: `release: vX.Y.Z - <one-line summary in English>`
3. Push to origin main
4. IMPORTANT: Never force push

## Step 5: Build

1. Run `flutter build appbundle --release` for the Play Store (AAB)
2. Run `flutter build apk --release` for GitHub (APK)
3. Report the file sizes and paths of both artifacts

## Step 6: GitHub Release

1. Create a git tag `vX.Y.Z`
2. Push the tag
3. Use `gh release create vX.Y.Z` with:
   - Title: `vX.Y.Z`
   - Body: the GitHub release notes from Step 3
   - Attach the APK file (NOT the AAB - that's for Play Store only)
4. Print the release URL

## Step 7: Play Store instructions

Since we can't upload to Play Store programmatically, print clear instructions:
```
Play Store - a faire manuellement :
1. Ouvrir Google Play Console -> EasyDiet -> Production
2. Uploader le AAB : <path>
3. Coller le changelog :
<changelog>
4. Publier
```

## Important rules
- NEVER skip the version bump
- NEVER commit files that contain secrets (.env, key.properties, *.jks, *.keystore)
- Always write changelogs in French
- The APK goes to GitHub, the AAB goes to Play Store
- If any build fails, diagnose the error before retrying
