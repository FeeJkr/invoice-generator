const puppeteer = require('puppeteer');
const express = require('express');
const Twig = require('twig');
const app = express();
const port = 3000;

app.use(express.json());

app.post('/v1/invoice/generate', (request, response) => {
    const parameters = request.body.parameters;
    const filename = './templates/{country}.html.twig'.replace('{country}', request.body.country);

    Twig.renderFile(filename, {...parameters}, (err, html) => {
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
            response.send(error);
        });
    });
})

app.listen(port);
