const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });

  const page = await browser.newPage();

  // Set mobile viewport (iPhone 12 Pro size)
  await page.setViewport({
    width: 390,
    height: 844,
    deviceScaleFactor: 2
  });

  await page.goto('http://localhost:4173', {
    waitUntil: 'networkidle0'
  });

  await page.screenshot({
    path: '/tmp/mobile-screenshot.png',
    fullPage: true
  });

  console.log('Screenshot saved to /tmp/mobile-screenshot.png');

  await browser.close();
})();
