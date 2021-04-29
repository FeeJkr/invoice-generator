const puppeteer = require('puppeteer');
const express = require('express');
const app = express();
const port = 3000;

app.use(express.json());

app.post('/html-to-pdf', (request, response) => {
    const html = request.body.html;

    (async () => {
        const browser = await puppeteer.launch({
            headless: true,
            args: ['--no-sandbox', '--disable-setuid-sandbox'],
        });
        const page = await browser.newPage();
        await page.setContent(html);
        const pdf = await page.pdf({format: 'A4'});
        await browser.close();

        return pdf;
    })().then(pdf => {
        response.set({'Content-Type': 'application/pdf'});
        response.send(pdf);
    }).catch(error => {
        response.status(500);
        console.log(error);
        response.send(error);
    });
})

app.listen(port);
