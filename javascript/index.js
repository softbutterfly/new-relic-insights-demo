const puppeteer = require('puppeteer');
const dotenv = require('dotenv');
const fs = require('fs');
dotenv.config();

const EVENT_TYPE = 'PageScanning';
const ENDPOINT = 'https://www.gob.pe/';
const timestamp = Math.round(new Date().getTime() / 1000);

(async () => {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();

    await page.setViewport({
        width: 1366,
        height: 768,
        deviceScaleFactor: 1,
    });
    await page.goto(ENDPOINT);

    await page._client.send('Performance.enable', { waitUntil: 'networkidle0' });
    let perfEntries = JSON.parse(
        await page.evaluate(() => JSON.stringify(performance.getEntries()))
    );
    perfEntries = perfEntries.map(entry => {
        return Object.assign({
            endpoint: ENDPOINT,
            eventType: EVENT_TYPE,
            timestamp: timestamp,
        }, entry)
    })

    await browser.close();

    fs.writeFile('pageScanning.json', JSON.stringify(perfEntries), function (err) {
        if (err) throw err;
        console.log('Saved!');
    });
})();
