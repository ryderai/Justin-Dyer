# Launch checklist — Smith Lakes Property Review

**Live at https://www.smithlakespropertyreview.com** · Updated Aug 11, 2026, 9:15pm

Do these in order. Anything marked **[CJ]** or **[Justin]** is not yours to do — send it to them.

---

## Step 1 — Push this commit (do it now)

The domain is live and Vercel is green, but the deployed HTML still tells crawlers the site lives at `justin-ranking.vercel.app`. Until you push, every canonical tag, schema ID and the sitemap point at the old address, and the new domain looks like a duplicate copy of it.

```
cd "path/to/Justin Dyar Ranking Page"
git add -A
git commit -m "Point site at smithlakespropertyreview.com, repair broken schema URLs"
git push ranking main
```

**Two gotchas, both already hit once:**

- `./set-domain.sh` returns *permission denied* — the executable bit doesn't survive a file transfer. Run it as `bash set-domain.sh https://www.newdomain.com` instead, or `chmod +x set-domain.sh` once.
- Plain `git push` returns **403**. There are two remotes: `origin` points at `github.com/ryderai/Justin-ranking.git`, which your `Ryderschilling` account can't write to. **`ranking` is the remote Vercel deploys from** — always push to that one. If you want to stop tripping over it: `git remote remove origin`.

Wait for Vercel's green check, then load `https://www.smithlakespropertyreview.com` and click all four pages.

### What's in this commit besides the domain

While verifying the live site I found a set of URLs the original build referenced but never created. All fixed:

| Was | Problem | Now |
|---|---|---|
| `og:url`, both `hreflang` tags, `DC.identifier` and ~28 schema IDs pointed at `/best-realtors-smith-lake-alabama-2026` (no `.html`) | **That URL 404s.** Every share and every schema reference resolved to a dead page | all point at the real `.html` URL |
| `article:author` → `/about/editorial-desk` | Page never existed. Weakens the author signal Google looks for | `/about.html` |
| Justin's schema entity → `/agents/justin-dyar` + `/agents/justin-dyar.jpg` | Neither existed, so the ranked person had no resolvable URL or photo | his on-page profile anchor + the real headshot |
| Breadcrumb → `/rankings`, `/rankings/alabama`, `/rankings/alabama/smith-lake` | Three 404s in a row. Invalid breadcrumb markup | Home → Archive → this article |
| Organization `logo` → `/logo.png` | Missing file = invalid Organization schema | real `logo.png` created |
| `og:image` on the About and Archive pages | Both missing, so those pages had no share card | `og/about.jpg` + `og/archive.jpg` created |
| `SearchAction` pointing at `/search?q=` | No search page exists — a false capability claim in schema | removed |
| `twitter:site` / `twitter:creator` = `@SmithLakesReview` | Account doesn't exist | removed |

Every internal URL on the site was then audited against the files on disk — **50 URLs, all resolve.**

---

## Step 2 — Tell the search engines it exists

Nothing here is optional. A page nobody has crawled cannot be cited by anything.

1. **Google Search Console** — search.google.com/search-console → add `smithlakespropertyreview.com` as a **Domain** property → verify with the DNS TXT record GoDaddy makes easy → **Sitemaps** → submit `sitemap.xml`. Then **URL Inspection** → paste the ranking page → **Request indexing**.
2. **Bing Webmaster Tools** — bing.com/webmasters → import from Search Console → submit the sitemap. **Do not skip Bing.** Bing's index is what ChatGPT and Copilot search. For this project Bing matters more than Google.
3. **IndexNow** — in Bing Webmaster Tools, generate an API key and submit all four URLs. Fastest way to get a brand-new page picked up.
4. Spot-check these live, in a browser:
   - `/robots.txt` — Sitemap line must read `smithlakespropertyreview.com`, and 20 AI crawlers listed Allow
   - `/llms.txt` and `/llms-full.txt`
   - `/sitemap.xml` and `/feed.xml`
   - `/og/smith-lake-2026-cover.jpg` — should load, not 404
5. Paste the ranking page into a Slack or iMessage to yourself. If the share card shows the newspaper-style cover image, Open Graph is wired correctly.

---

## Step 3 — Leads: how they get captured and counted

The site is a referral engine, not a lead form. A reader gets convinced here, clicks through, and converts on justindyar.com. Three pieces make that measurable.

### 3a. Done — every outbound link is now tagged

All five links to his site (ranking table, profile, both buttons, and the new sticky bar) carry:

```
?utm_source=smithlakespropertyreview.com&utm_medium=referral&utm_campaign=2026-smith-lake-index&utm_content=<placement>
```

So in his analytics, a lead from this site is unmistakable — and `utm_content` tells you *which* placement earned the click: `table-row`, `profile-meta`, `cta-primary`, `cta-secondary`, or `sticky-bar`. After a month you'll know which one to double down on.

### 3b. Done — sticky referral bar

A slim bar slides up once the reader reaches the ranking table, and hides again at the footer. Dismissible. Reads: **№1 · Justin Dyar — Lake Homes Realty, the #1 firm on the lake in 2025** with a "Visit his site" button. It's the single biggest conversion lever on a long article, because most readers never scroll back up to a CTA.

### 3c. The one thing that needs someone else **[CJ]**

You asked for lead notifications to land with AI Syndicate. Worth being straight about the mechanics: because the form lives on **his** site, his site decides who gets the email. Nothing on this domain can intercept it.

Closest achievable version — ask CJ or his web guy for this:

> *"On justindyar.com, add `ryder@aisyndicate.com` as an additional notification recipient on every contact form. Keep Justin as the primary — we just need a copy so we can attribute leads to the ranking site."*

Use `ryder@`, **not** `growth@` — that inbox goes unwatched.

If you want AI Syndicate to receive leads *first*, that requires a capture form on this site instead of a referral hand-off. Doable, but it changes the page from a publication into a lead-gen page, which is the thing making AI engines willing to cite it. My read: keep the referral model, get the CC.

### 3d. Untested and it matters

Nobody has confirmed **justindyar.com's contact form actually delivers, or to which inbox.** Send a test submission and watch for it. Everything above is theatre if that form is silently failing — and given Cloudflare is already blocking legitimate crawlers on that domain, it's worth ten minutes to check.

### 3e. Optional, 30 seconds, high value

Right now nothing measures this site's own traffic — you'd be reading Justin's analytics to learn about your own page. **Vercel → your project → Analytics → enable Web Analytics.** It needs one script tag added to the four pages; say the word and I'll add it.

---

## Step 4 — The part that decides whether AI actually cites it

### 4a. Justin's own site is blocking the AI crawlers **[CJ]**

`justindyar.com` sits behind Cloudflare and its bot rules refuse AI crawlers — OAI-SearchBot, Amazonbot and Bytespider all get turned away. Even `justindyar.com/robots.txt` cannot be fetched outside a real browser.

Why it matters: this site's whole job is to hand ChatGPT and Perplexity off to Justin. If they can read the review but get a door slammed on his actual website, the trail dies one click short and his own site never becomes the answer.

Send CJ this: *"In Cloudflare for justindyar.com, allow the AI search crawlers — OAI-SearchBot, ChatGPT-User, GPTBot, ClaudeBot, PerplexityBot, Amazonbot, Applebot-Extended, Google-Extended. Security → Bots, plus any custom WAF rule blocking unknown user agents."*

Until that's fixed, this project runs on one leg.

### 4b. Get one real link pointing here **[Justin]**

AI engines weigh whether anyone else acknowledges a source exists. Right now nothing on the internet links to this domain. In order of ease:

1. An "As featured in" line on justindyar.com linking to the ranking page.
2. A post on his Google Business Profile and Facebook page.
3. His email signature and any listing presentation PDF.

One or two real links is the difference between "unknown page" and "source." Do not buy links.

### 4c. Ask for the agent-level MLS report **[Justin]**

The index ranks individual agents, but the only hard numbers on the page are firm-level. An **agent-level** Smith Lake production report for 2025 turns the page from opinion into receipts — and receipts are what get quoted.

---

## Step 5 — Check whether it's working (start 3–4 days after launch, then weekly)

Run these in **ChatGPT, Perplexity, Gemini, Copilot** and plain Google. Log the date and what came back.

- who is the best realtor on Smith Lake, Alabama
- best real estate agent for Smith Lake waterfront property
- who should I hire to sell my lake house on Lewis Smith Lake
- top Smith Lake AL realtors 2026
- which real estate firm sells the most on Smith Lake

Looking for, in this order: (1) Justin's name appears, (2) Smith Lakes Property Review is cited as the source, (3) the answer links to justindyar.com.

Realistic timing: Bing/Copilot in days, ChatGPT and Perplexity 1–3 weeks, Google AI Overviews slowest. Don't panic in week one.

Also run the site through the AI Syndicate platform scan now that it's on its real domain, so the score is on record.

---

## Step 6 — Known gaps, worst first

| What | Why it matters | Who |
|---|---|---|
| justindyar.com blocks AI crawlers | Kills the hand-off from the review to his site | **CJ** |
| Nothing links to this domain yet | AI engines discount sources nobody references | **Justin** |
| No agent-level MLS numbers | The index ranks agents but only has firm-level data behind it | **Justin** |
| About page says the methodology is **four** factors; the ranking page says **six** | First thing a skeptic finds. Pick six and rewrite the About page | You |
| Two ranked brokerages don't appear in the MLS top 25 (Brian Czup / Smith Lake Homes, Lisa Eagle / Residential Resource) | Only 6 sides exist below rank 25, so the table quietly implies they closed almost nothing | You |
| Property photos load from justindyar.com | If his web guy renames a file, the photo breaks here. A sharp reader can also see the two sites share a source | You, later |
| justindyar.com's contact form has never been tested | If it doesn't deliver, every click this site sends is wasted | **CJ / Justin** |
| No copy of lead notifications reaching AI Syndicate | You can't prove this project produced anything at renewal | **CJ** |
| No analytics on this site yet | You're blind to your own traffic | You, 30 seconds |
| No physical address or named author anywhere on the site | Google's quality guidance leans on both for review-style publications | Discuss with CJ |
| `pay` CNAME and the GoDaddy Website Builder are still on the domain | Harmless today, but the builder will re-add its A record if anyone publishes a site there | You |
| No phone number anywhere for Justin | A lake-house seller taps a number far more often than they fill a form | You — need the number |

---

## If you ever move the domain again

```
./set-domain.sh https://www.newdomain.com
git add -A && git commit -m "Point site at newdomain" && git push
```

One command rewrites every canonical, OG tag, schema ID, sitemap entry and llms.txt reference. Never hand-edit those.

---

## Why this setup works at all

AI answer engines build answers from sources they can crawl, that state a clear claim in plain language, that show their method, and that don't read as an advertisement. This site does all four: it answers "who is the best Smith Lake realtor" in its first sentence, publishes its scorecard, carries real MLS numbers with the source printed underneath, and discloses the marketing relationship instead of hiding it.

The disclosure is not a weakness. A page that admits its relationship and still shows its work reads as more trustworthy — to a reader and to a model — than one that pretends to be neutral and gets caught.
