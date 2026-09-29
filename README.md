# WEB-Startr.llc

The company page for Startr LLC at <https://startr.llc>: who we are, our
brands, how to reach us, and where our legal documents live.

One static file, `public/index.html`, styled with
[startr.style](https://startr.style). No build step. Same shape as
<https://plante.somma.consulting>.

## Use

- `make it_run` serves `public/` at <http://localhost:8090>
- `make check` confirms every link answers and every icon and image exists
- `make deploy` runs the check, then uploads `public/` to Cloudflare Pages

## Icons and link previews

Sources live in `design/`; outputs in `public/` are committed.

- `make social` renders `design/social-card.html` to the 1200x630 preview card
- `make favicon` renders the S monogram used below 48px
- `make icons` builds every icon from the logo and that monogram

The renders use puppeteer from another checkout (`PUPPETEER_NODE_PATH`,
default WEB-Sage.is). ImageMagick builds the icons.

## Facts on the page

The legal name, entity type and address must match
`WEB-Sage.is/src/_data/site.yaml` (the `legal:` block). Change them there
and here together, including the JSON-LD block in the page head.
