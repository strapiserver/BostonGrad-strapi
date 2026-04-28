# Strapi Schema Context

Updated: 2026-03-28
Project path: `/Users/admin/DEV/BostonGrad/strapi`

## Scope
This document summarizes schema definitions found in:
- `src/api/*/content-types/*/schema.json`
- `src/components/**/*.json`

It intentionally excludes plugin and `node_modules` schemas.

## Content Types

### `api::article.article` (collectionType, i18n enabled)
- Collection: `articles`
- Draft/Publish: `false`
- Fields:
- `header`: string, max 200, localized
- `subheader`: string, max 300, localized
- `code`: string, required, non-localized
- `chapters`: json, localized
- `stats`: json, localized
- `seo_title`: string, localized
- `seo_description`: string, localized
- `preview`: media(image), single, non-localized
- `wallpaper`: media(image), single, non-localized
- `text`: richtext, non-localized
- `type`: enum(`generated|blog|page`), default `blog`, non-localized

### `api::click.click` (collectionType)
- Collection: `clicks`
- Draft/Publish: `false`
- Fields:
- `identificator`: string, required
- `fingerprint`: string, required, unique
- `userAgent`: string
- `ipAddress`: string
- `location`: string

### `api::country.country` (collectionType)
- Collection: `countries`
- Draft/Publish: `false`
- Fields:
- `name`: string, required
- `preposition`: string
- `rank`: integer

### `api::main-text.main-text` (collectionType, i18n enabled)
- Collection: `main_texts`
- Draft/Publish: `false`
- Fields:
- `title`: string, localized
- `description`: text, localized
- `image`: media(image), single, non-localized
- `rank`: integer, private, non-localized
- `link`: component `shared.link` (single), localized

### `api::office.office` (collectionType)
- Collection: `offices`
- Draft/Publish: `false`
- Fields:
- `coordinates`: string, required, regex for `lat,lng`
- `city`: string, required
- `visible`: boolean, default `true`
- `working_time`: string
- `image`: media(image), single
- `description`: text, max 1000
- `address`: string, required

### `api::review-category.review-category` (collectionType, i18n enabled)
- Collection: `review_categories`
- Draft/Publish: `false`
- Fields:
- `title`: string, required, localized
- `image`: media(image), multiple, non-localized
- `description`: text, localized
- `isNegative`: boolean, default `false`, localized
- `rank`: integer, non-localized

### `api::review-reply.review-reply` (collectionType)
- Collection: `review_replies`
- Draft/Publish: `false`
- Fields:
- `text`: string, required, max 10000
- `review`: relation manyToOne -> `api::review.review` (inversedBy `review_replies`)
- `screenshots`: media(image), multiple
- `from`: enum(`author|admin|exchanger`), required
- `iaApproved`: boolean

### `api::review.review` (collectionType)
- Collection: `reviews`
- Draft/Publish: `false`
- Fields:
- `fingerprint`: string, unique, optional
- `text`: text, required, max 10000
- `screenshots`: media(image), multiple
- `type`: enum(`positive|neutral|negative|question`), required
- `isDispute`: boolean
- `isClosed`: boolean
- `isApproved`: boolean
- `admin_comment`: string, private
- `ipAddress`: string
- `userAgent`: string
- `location`: string
- `ai_data`: json
- `review_replies`: relation oneToMany -> `api::review-reply.review-reply` (mappedBy `review`)
- `honeypot`: string, max 120
- `telegram`: string
- `whatsapp`: string
- `name`: string
- `review_categories`: relation oneToMany -> `api::review-category.review-category`
- `isExchangeDone`: boolean
- `gossip`: string, max 1000
- `isVerified`: boolean

### `api::reviews-category.reviews-category` (singleType, i18n enabled)
- Collection: `reviews_categories`
- Draft/Publish: `false`
- Fields (all localized json):
- `positive`
- `neutral`
- `negative`
- `question`

### `api::text-box.text-box` (collectionType, i18n enabled)
- Collection: `text_boxes`
- Draft/Publish: `false`
- Fields:
- `header`: string, localized
- `subheader`: string, localized
- `text`: text, localized
- `key`: string, required, non-localized
- `seo_title`: string, localized
- `seo_description`: string, localized

### `api::x-faq-category.x-faq-category` (collectionType, i18n enabled)
- Collection: `x_faq_categories`
- Draft/Publish: `false`
- Fields:
- `code`: string, required, localized
- `description`: text, localized
- `image`: media(image), single, localized
- `color`: enum(gray/red/orange/yellow/green/teal/blue/cyan/purple/pink + dark_* variants), localized
- `rank`: integer, localized
- `x_faqs`: relation oneToMany -> `api::x-faq.x-faq` (mappedBy `x_faq_category`)

### `api::x-faq.x-faq` (collectionType, i18n enabled)
- Collection: `x_faqs`
- Draft/Publish: `false`
- Fields:
- `question`: string, required, localized
- `response`: text, required, localized
- `x_faq_category`: relation manyToOne -> `api::x-faq-category.x-faq-category` (inversedBy `x_faqs`)

## Components

### `article.chapter`
- Collection: `components_article_chapters`
- Fields:
- `title`: string, max 200
- `text`: richtext, required
- `link`: component `shared.link`, repeatable
- `disclaimer`: component `article.disclaimer`, single

### `article.disclaimer`
- Collection: `components_article_disclaimers`
- Fields:
- `title`: string, max 300
- `text`: string, max 240
- `color`: enum(`green|red|yellow`), required, default `yellow`

### `shared.color`
- Collection: `components_shared_colors`
- Field:
- `color`: enum of gray/red/orange/.../dark_pink, required, default gray
- Note: enum values in JSON currently include leading spaces (for example `"    gray"`), which may be unintended.

### `shared.link`
- Collection: `components_shared_links`
- Fields:
- `text`: string, max 250, optional
- `href`: string
- `isExternal`: boolean, required, default `true`
- `isBlank`: boolean, required, default `true`

### `shared.meta-social`
- Collection: `components_shared_meta_socials`
- Fields:
- `socialNetwork`: enum(`Facebook|Twitter`), required
- `title`: string, required
- `description`: string, required
- `image`: media(single; allowed: images/files/videos)

### `shared.seo`
- Collection: `components_shared_seos`
- Fields:
- `metaTitle`: string, required, max 60
- `metaDescription`: string, required, min 50, max 160
- `metaImage`: media(single), required, allowed: images/files/videos
- `metaSocial`: component `shared.meta-social`, repeatable
- `keywords`: text, regex `[^,]+`
- `metaRobots`: string, regex `[^,]+`
- `structuredData`: json
- `metaViewport`: string
- `canonicalURL`: string

## Relation Map (Quick)
- `review` 1 -> N `review-reply`
- `x-faq-category` 1 -> N `x-faq`
- `main-text` embeds `shared.link`
- `article.chapter` embeds `shared.link[]` and `article.disclaimer`
- `shared.seo` embeds `shared.meta-social[]`

## Notes For Future Changes
- Many models are i18n-localized; when adding fields, explicitly decide localized vs non-localized.
- `review.review_categories` is defined as oneToMany without explicit inverse in `review-category`; verify intended direction before extending.
- `shared.color` enum values appear whitespace-prefixed and may need cleanup if used by exact match logic.

## FRONT DEPLOY - IMPORTANT

# NEVER DEPLOY FRONT THROUGH DOCKER

# ALLOWED GITHUB REMOTES - IMPORTANT

# NEVER USE ANY GITHUB REMOTE FOR THIS PROJECT EXCEPT:
# - https://github.com/strapiserver/BostonGrad-strapi.git
# - https://github.com/strapiserver/BostonGrad-front.git

Do not add, push to, pull from, inspect for deployment, or otherwise use other GitHub remotes for BostonGrad project work.
The old monorepo remote `https://github.com/strapiserver/BostonGrad.git` is not the deployment target anymore.
Each deployable folder owns its own git repository:
- `/Users/admin/DEV/BostonGrad/strapi` -> `https://github.com/strapiserver/BostonGrad-strapi.git`
- `/Users/admin/DEV/BostonGrad/front` -> `https://github.com/strapiserver/BostonGrad-front.git`

Current local git layout:
- The project root `/Users/admin/DEV/BostonGrad` is not a git repository.
- `/Users/admin/DEV/BostonGrad/strapi` is its own git repository. Its only allowed remote is `origin = https://github.com/strapiserver/BostonGrad-strapi.git`.
- `/Users/admin/DEV/BostonGrad/front` is its own git repository. Its only allowed remote is `origin = https://github.com/strapiserver/BostonGrad-front.git`.
- Do not initialize, add, fetch, pull, push, or inspect any other remote for BostonGrad work unless the user explicitly changes this rule.

# FRONT DEPLOY IS ONLY:
# 1. COMMIT FRONTEND CHANGES TO GIT
# 2. PUSH TO GITHUB
# 3. VERCEL PICKS UP THE GITHUB COMMIT AND DEPLOYS

Do not build or run the frontend with Docker for deployment.
Do not use `docker build`, `docker run`, or `docker compose up` for frontend deploy.
Do not document Docker as a frontend deploy path.

The frontend lives in `/Users/admin/DEV/BostonGrad/front`, but production deploy is owned by Vercel through GitHub.

Correct frontend deploy flow:

```bash
cd /Users/admin/DEV/BostonGrad
cd front
git status
git add .
git commit -m "<meaningful frontend change message>"
git pull --rebase origin main
git push origin main
```

After GitHub receives the commit, Vercel deploys automatically.

## Strapi Deploy Note

# STRAPI SERVER TARGET - IMPORTANT

# NEVER TOUCH P2PIE SERVERS OR P2PIE CONTAINERS

# NEVER MODIFY STRAPI DATA VOLUME / DATABASE UNLESS THE USER EXPLICITLY ASKS TO RESTORE IT

The Strapi `data` volume contains the production database.
Do not edit, overwrite, delete, migrate manually, or otherwise modify the Strapi `data` volume or database as a routine deploy step.
Deploying Strapi code means replacing/restarting the container image only; it does not mean changing the database volume.
Database restore is a separate destructive operation and requires an explicit user request in the current conversation.

Do not deploy, restart, inspect, or modify anything on `p2pie` hosts.
Do not use the `172.16.12.91` target from `newbackup.sh` for BostonGrad work.
That host belongs to p2pie and is forbidden for this project.

BostonGrad Strapi server access:

```bash
ssh strapi@10.0.0.190
```

Password/code word: `strapi`

Use this host for BostonGrad Strapi deploy/restart work.

Strapi changes do not appear on the server just because local files or local data changed.
For schema changes like `api::allbenefit.allbenefit` and `api::benefit.benefit` to appear on the server, the server must run a Strapi image/container that includes those files.

Required Strapi deploy flow:
- Build the Strapi Docker image from `/Users/admin/DEV/BostonGrad/strapi`.
- Push the image tag used by the server.
- Restart/recreate the remote Strapi container so it pulls/runs the new image.
- Only after that, verify remote GraphQL exposes the new schema.

If Docker Hub push fails or the remote container is not restarted, the server will still run the old Strapi code and fields like `allbenefit` will not exist remotely.

Actual working BostonGrad Strapi deploy path used on 2026-04-28:

```bash
cd /Users/admin/DEV/BostonGrad/strapi
docker build -t darkshrine/strapi:latest .

cd /Users/admin/DEV/BostonGrad
docker save darkshrine/strapi:latest | gzip -1 | \
  sshpass -p 'strapi' ssh \
    -o PubkeyAuthentication=no \
    -o PreferredAuthentications=password \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    strapi@10.0.0.190 'gunzip | docker load'

sshpass -p 'strapi' ssh \
  -o PubkeyAuthentication=no \
  -o PreferredAuthentications=password \
  -o StrictHostKeyChecking=no \
  -o UserKnownHostsFile=/dev/null \
  strapi@10.0.0.190 '
    cd /home/strapi
    docker rm -f strapi
    docker-compose up -d --no-deps strapi
  '
```

Notes for this server:
- Force password auth with `PubkeyAuthentication=no`; otherwise SSH can hang while trying the local key.
- The server compose file is `/home/strapi/docker-compose.yml`.
- The running container name is `strapi`.
- The compose service uses `image: darkshrine/strapi:latest`.
- If Docker Hub push is unreliable, direct `docker save | gzip | ssh docker load` is the working path.
- Do not remove Docker volumes when recreating the container; content lives in the `data`, `public`, and `config_sync` volumes.

Verification after deploy:

```bash
curl -sS -X POST https://cms.bostongrad.com/graphql \
  -H 'Content-Type: application/json' \
  --data-binary '{"query":"query { allbenefit(locale: \"ru\") { data { id attributes { title benefits(pagination: { limit: 20 }, sort: [\"rank:asc\"]) { data { id attributes { title rank } } } } } } }"}'
```

Expected result: `allbenefit` exists and returns 13 benefits with ranks `1..13`.

Database restore/rollback note from 2026-04-28:
- User explicitly forbade modifying the Strapi `data` volume/database as part of normal work.
- A safety backup was created before rollback at `/home/strapi/backup-before-restore-20260428-005343/data.tar.gz`.
- The rollback did not restore an old archive over the whole volume. It removed only the records that had been added during the accidental DB write:
  - `allbenefits`: 1 row
  - `benefits`: 13 rows
- `allbenefits_benefits_links`: 13 rows
- public permissions for `api::allbenefit.allbenefit.*` and `api::benefit.benefit.*`
- After restart, public GraphQL for `allbenefit` returned `Forbidden access`, confirming the accidental public data/permissions were removed.

Correction after mistaken rollback:
- The Strapi image should NOT have been rolled back. The correct state is the new image with the new schema active.
- `darkshrine/strapi:latest` was restored to `sha256:aab3ac3c6c277662733223a5a9aa125b922406df5126692bf3fa9cdf3ac9520b`.
- The `strapi_data` volume was restored from `/home/strapi/backup-before-restore-20260428-005343/data.tar.gz`.
- Then user clarified that this was still one step too far forward: `benefit` was supposed to be zero.
- A safety backup was created before zeroing again at `/home/strapi/backup-before-benefit-zero-restore-20260428-022208/data.tar.gz`.
- Final corrected state:
  - running container image remains new: `sha256:aab3ac3c6c277662733223a5a9aa125b922406df5126692bf3fa9cdf3ac9520b`
  - DB counts: `allbenefits=0`, `benefits=0`, `allbenefits_benefits_links=0`
  - public permissions for `api::allbenefit.allbenefit.*` and `api::benefit.benefit.*` are removed
  - external GraphQL at `https://cms.bostongrad.com/graphql` returns `Forbidden access` for `allbenefit`

Question data volume restore:
- User reported `api::question.question` was empty and explicitly requested restoring the volume until it was not empty.
- A safety backup was created before this restore at `/home/strapi/backup-before-question-restore-20260428-022643/data.tar.gz`.
- Restored `strapi_data` from `/home/strapi/BostonGrad/backups/20260416-201246/data.tar.gz`.
- Verification after restore:
  - `questions=6`
  - `questions_components=3`
  - `responses_question_links=35`
  - admin URL for `api::question.question` returns HTTP 200
  - running Strapi image remains `sha256:aab3ac3c6c277662733223a5a9aa125b922406df5126692bf3fa9cdf3ac9520b`

Media library restore after question DB restore:
- Restoring only `strapi_data` can break the media library if `strapi_public` does not match the restored DB's `files` table.
- Matching public backup for `/home/strapi/BostonGrad/backups/20260416-201246/data.tar.gz` is `/home/strapi/BostonGrad/backups/20260416-201246/public.tar.gz`.
- A safety backup was created before restoring public at `/home/strapi/backup-before-public-restore-20260428-025904/public.tar.gz`.
- Restored `strapi_public` from `/home/strapi/BostonGrad/backups/20260416-201246/public.tar.gz`.
- Verification after restore:
  - DB `files` records: 30
  - missing files under `/opt/app/public`: 0
  - `https://cms.bostongrad.com/admin/plugins/upload` returns HTTP 200
  - a referenced upload URL returns HTTP 200

Hourly Strapi DB volume backups:
- Server: `strapi@10.0.0.190`
- Script: `/home/strapi/bin/backup-strapi-data-volume.sh`
- Volume: `strapi_data`
- Backup directory: `/home/strapi/volume-backups/strapi_data`
- Cron: `0 * * * * /home/strapi/bin/backup-strapi-data-volume.sh >/dev/null 2>&1`
- Retention: keep newest 100 files matching `strapi_data-*.tar.gz`; delete older ones after each successful backup.
- The script uses `flock` so overlapping backup runs exit without modifying anything.
- First immediate backup created: `/home/strapi/volume-backups/strapi_data/strapi_data-20260428-023117.tar.gz`.
