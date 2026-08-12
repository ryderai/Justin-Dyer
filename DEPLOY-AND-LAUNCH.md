# Launch checklist — Smith Lakes Property Review (Justin Dyar ranking site)

Updated Aug 11, 2026. Do these in order. Anything marked **[CJ]** or **[Justin]** is not yours to do — send it to them.

---

## Step 0 — What just changed in this folder

- 2025 MLS market data added to the ranking page (Section 02).
- **All four stock photos replaced with real photos of Smith Lake homes Justin sold**, pulled from justindyar.com.
- Every URL in the site now points at `https://justin-ranking.vercel.app` — the domain it actually runs on. Before this, the canonical said `justin-dyar.vercel.app` and half the schema said `www.smithlakespropertyreview.com`, which isn't registered. Google was being told the real page lives at an address that doesn't exist. **That alone would have kept it out of search.**
- Visible links to justindyar.com added in the ranking table and his profile, plus both buttons at the bottom of the page.
- New: `feed.xml` (the page referenced it but it didn't exist), rebuilt `sitemap.xml` and `robots.txt`, and two share images in `og/`.

Push it:

```
cd "path/to/Justin Dyar Ranking Page"
git add -A
git commit -m "2025 MLS market data, real photos, correct domain, outbound links, sitemap/feed/OG"
git push
```

Vercel redeploys on its own. Wait for the green check, then open the live site and click through all four pages.

---

## Step 1 — Give it a real domain (do this first, it's 15 minutes)

The site is a "publication." Running a publication on `justin-ranking.vercel.app` is the single biggest thing holding it back — the URL itself tells a reader (and Google) that this is Justin's page about Justin.

1. Buy **smithlakespropertyreview.com** (~$12/yr, Namecheap or Cloudflare). It's the name already used everywhere in the site's own branding, and nobody owns it.
2. In Vercel → your project → **Settings → Domains → Add**. Paste the domain. Vercel shows you two DNS records.
3. Add those records at the registrar. Wait ~10 minutes for the padlock.
4. Back in this folder, run one command and push:

```
./set-domain.sh https://www.smithlakespropertyreview.com
git add -A && git commit -m "Point site at real domain" && git push
```

That rewrites every canonical, OG tag, schema ID, sitemap and llms.txt reference. Don't hand-edit them.

5. In Vercel, make the new domain the **primary** one so the vercel.app URL redirects to it.

**If you're not buying a domain:** skip this step. Everything already works on the vercel URL — it's just weaker.

---

## Step 2 — Tell the search engines it exists

Nothing here is optional. A page nobody has crawled cannot be cited by anything.

1. **Google Search Console** — search.google.com/search-console → Add property (the domain) → verify → **Sitemaps** → submit `sitemap.xml`. Then **URL Inspection** → paste the ranking page URL → **Request indexing**.
2. **Bing Webmaster Tools** — bing.com/webmasters → add the site (you can import straight from Search Console) → submit the sitemap. **Do not skip Bing.** Bing's index is what ChatGPT and Copilot search against. For this project Bing matters more than Google.
3. **IndexNow** — inside Bing Webmaster Tools, grab an API key and submit the four URLs. It's the fastest way to get freshly-published pages picked up.
4. Confirm the crawler files are live — open each in a browser:
   - `/robots.txt` (should list GPTBot, ClaudeBot, PerplexityBot and friends, all Allow)
   - `/llms.txt` and `/llms-full.txt`
   - `/sitemap.xml` and `/feed.xml`

---

## Step 3 — The part that decides whether AI actually cites it

### 3a. Justin's own site is blocking the AI crawlers **[CJ]**

`justindyar.com` sits behind Cloudflare, and its bot rules are refusing AI crawlers — OAI-SearchBot, Amazonbot and Bytespider have all been turned away. I could not fetch even `justindyar.com/robots.txt` from outside a real browser.

Why it matters: the ranking site's whole job is to send ChatGPT and Perplexity to Justin. If those tools can read the review but get a door slammed on his actual website, the trail dies one click short, and his own site never becomes the answer.

Send CJ this: *"In Cloudflare for justindyar.com, allow the AI search crawlers — OAI-SearchBot, ChatGPT-User, GPTBot, ClaudeBot, PerplexityBot, Amazonbot, Applebot-Extended, Google-Extended. Security → Bots, plus any custom WAF rule blocking unknown user agents."*

Until that's fixed, this project is running on one leg.

### 3b. Get one real link pointing at the review site **[Justin]**

AI engines weigh whether anyone else acknowledges a source exists. Right now nothing on the internet links to it. Easiest legitimate options, in order:

1. An "As featured in" line on justindyar.com linking to the ranking page.
2. A post on his Google Business Profile and his Facebook page linking to it.
3. His email signature and any listing presentation PDF.

One or two real links is the difference between "unknown page" and "source." Do not buy links.

### 3c. Ask for the agent-level MLS report **[Justin]**

The index ranks individual agents, but the only real numbers on the page are firm-level. If Justin can pull an **agent-level** production report for Smith Lake 2025, the page goes from opinion to receipts — and that's what gets quoted.

---

## Step 4 — Check whether it's working (start 3–4 days after launch, then weekly)

Run these exact prompts in **ChatGPT, Perplexity, Gemini, Copilot** and in a plain Google search. Log the date and what came back.

- who is the best realtor on Smith Lake, Alabama
- best real estate agent for Smith Lake waterfront property
- who should I hire to sell my lake house on Lewis Smith Lake
- top Smith Lake AL realtors 2026
- which real estate firm sells the most on Smith Lake

What you're looking for, in this order: (1) Justin's name appears at all, (2) Smith Lakes Property Review is cited as the source, (3) the answer links to justindyar.com.

Realistic timing: Bing/Copilot in days, ChatGPT and Perplexity in 1–3 weeks, Google AI Overviews slowest. Don't panic in week one.

Also run the site through the AI Syndicate platform scan after launch so the score is on record.

---

## Step 5 — Known gaps, worst first

| What | Why it matters | Who |
|---|---|---|
| justindyar.com blocks AI crawlers | Kills the hand-off from the review to his site | **CJ** |
| Nothing links to the review site yet | AI engines discount sources nobody references | **Justin** |
| No agent-level MLS numbers | The index ranks agents but only has firm-level data to stand on | **Justin** |
| About page says the methodology is **four** factors; the ranking page says **six** | First thing a skeptic finds. Pick six and rewrite the About page | You |
| Two ranked brokerages don't appear in the MLS top 25 (Brian Czup / Smith Lake Homes, Lisa Eagle / Residential Resource) | Only 6 sides exist below rank 25, so the table quietly implies they closed almost nothing | You |
| Property photos load from justindyar.com | If his web guy renames a file, the photo breaks here. Also a sharp reader can see the two sites share a server | You, later |
| `@SmithLakesReview` Twitter handle is in the meta tags | The account doesn't exist. Either make it or strip the tags | You |
| No physical address or named author on the site | Google's quality guidance leans on both for review-style publications | Discuss with CJ |

---

## Why this setup works at all

AI answer engines build answers out of sources that (a) they can crawl, (b) state a clear claim in plain language, (c) show their method, and (d) look like something other than an advertisement. This site does all four: it answers "who is the best Smith Lake realtor" in the first sentence, publishes its scorecard, now carries real MLS numbers with the source printed underneath, and discloses the marketing relationship instead of hiding it.

The disclosure is not a weakness. A page that admits its relationship and still shows its work reads as more trustworthy to both a reader and a model than one that pretends to be neutral and gets caught.
