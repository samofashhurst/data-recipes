# -*- coding: utf-8 -*-

# To run (e.g.):
#   1) pip install Scrapy
#   2) cd ~/projects/Scrapy
#   3) scrapy startproject reviews
#   4) paste this file into ~/projects/Scrapy/reviews/reviews/spiders
#   5) edit urls, fields, and css/xpath selectors to match the page(s) you want to scrape
#   6) cd ~/projects/Scrapy/reviews
#   7) scrapy crawl reviews -o <<filename>>.jl

import scrapy

class ReviewsSpider(scrapy.Spider):
    name = "reviews"
    start_urls = [
        'https://www.capterra.co.nz/reviews/130598/greenrope',
        #'https://www.capterra.co.nz/reviews/135686/accelo',
        #'https://www.capterra.co.nz/reviews/142037/nicejob'
    ]

    # Edit the below fields and css/xpath selectors as needed
    def parse(self, response):
        for review in response.css('div.i18n-translation_container'):
            yield {
                'title': review.xpath('descendant::h3/q/text()').get(),
                'date': review.css('span.ml-4::text').get().strip(),
                'overall-stars': review.css('div.h1::text').get(),
                'ease-of-use': review.xpath(
                    'descendant::div[text()="Ease of Use"]/parent::div/span/span[2]/text()').get(),
                'customer-support': review.xpath(
                    'descendant::div[text()="Customer Support"]/parent::div/span/span[2]/text()').get(),
                'features': review.xpath(
                    'descendant::div[text()="Features & Functionality"]/parent::div/span/span[2]/text()').get(),
                'value': review.xpath('descendant::div[text()="Value for Money"]/parent::div/span/span[2]/text()').get(),
                'likelihood': review.css('img.recommendation-range__img::attr(data-src)').get(),
                'comments': review.xpath('descendant::strong[text()="Comments: "]/following-sibling::span/text()').get(),   
                'pros': review.xpath('descendant::strong[text()="Pros: "]/following-sibling::span/text()').get(),  
                'cons': review.xpath('descendant::strong[text()="Cons: "]/following-sibling::span/text()').get(),  
            }

        # Handle pagination
        next_page = response.css('a[rel="next"]::attr(href)').get()
        if next_page is not None:
            next_page = response.urljoin(next_page)
            yield scrapy.Request(next_page, callback=self.parse)