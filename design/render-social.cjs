// Render design/social-card.html to public/assets/social-card.jpg at 1200x630.
// Needs puppeteer. This repo has no node_modules of its own, so point
// NODE_PATH at any checkout that has it (the Makefile defaults to WEB-Sage.is).
const path = require("node:path");
const puppeteer = require("puppeteer");

const root = path.join(__dirname, "..");
const src = "file://" + path.join(root, "design", "social-card.html");
const out = path.join(root, "public", "assets", "social-card.jpg");

(async () => {
  const browser = await puppeteer.launch({ headless: true });
  const page = await browser.newPage();
  await page.setViewport({ width: 1200, height: 630, deviceScaleFactor: 1 });
  await page.goto(src, { waitUntil: "networkidle0", timeout: 60000 });
  await page.evaluate(() => document.fonts.ready);
  const loaded = await page.evaluate(() =>
    [...document.images].every((img) => img.complete && img.naturalWidth > 0),
  );
  if (!loaded) throw new Error("an image failed to load; refusing to write a broken card");
  await page.screenshot({ path: out, type: "jpeg", quality: 88 });
  await browser.close();
  console.log("wrote", path.relative(root, out));
})().catch((err) => {
  console.error("render-social:", err.message);
  process.exit(1);
});
