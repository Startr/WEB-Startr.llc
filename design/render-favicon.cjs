// Render design/favicon.html to design/favicon-master.png (256x256, transparent
// outside the disc). design/make-icons.sh builds the small icons from it.
// Needs puppeteer via NODE_PATH, as for render-social.cjs.
const path = require("node:path");
const puppeteer = require("puppeteer");

const root = path.join(__dirname, "..");
const src = "file://" + path.join(root, "design", "favicon.html");
const out = path.join(root, "design", "favicon-master.png");

(async () => {
  const browser = await puppeteer.launch({ headless: true });
  const page = await browser.newPage();
  await page.setViewport({ width: 256, height: 256, deviceScaleFactor: 1 });
  await page.goto(src, { waitUntil: "networkidle0", timeout: 60000 });
  await page.evaluate(() => document.fonts.ready);
  const font = await page.evaluate(() => getComputedStyle(document.querySelector("span")).fontFamily);
  if (!/nunito/i.test(font)) throw new Error(`startr.style font did not load (got ${font})`);
  await page.screenshot({ path: out, omitBackground: true });
  await browser.close();
  console.log("wrote", path.relative(root, out));
})().catch((err) => {
  console.error("render-favicon:", err.message);
  process.exit(1);
});
