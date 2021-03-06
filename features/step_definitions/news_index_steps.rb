When(/^I visit the news page in (.*)$/) do |language|
  locale = language_to_locale(language)
  news_page.load(locale: locale)
end

When(/^I visit the news page$/) do
  step 'I visit the news page in English'
end

When(/^I visit the last news page$/) do
  news_page.load(locale: 'en', page_number: '53')
end

Then(/^I should( not)? see the 'Older' button$/) do |negate|
  if negate
    expect(news_page).to_not have_older_button
  else
    expect(news_page).to have_older_button
  end
end

Then(/^I should( not)? see the 'Newer' button$/) do |negate|
  if negate
    expect(news_page).to_not have_newer_button
  else
    expect(news_page).to have_newer_button
  end
end

Then(/^I see a list of news in (.*)$/) do |language|
  news = news(language)

  language_link = case language
  when 'English' then 'welsh_link'
  when 'Welsh'   then 'english_link'
  end

  expect(news_page.title).to eq("#{I18n.t('news.index.title')} - #{I18n.t('layouts.base.title')}")
  expect(news_page.items_titles.first.text).to eq(news.first.title)
  expect(news_page.items_dates.first.text).to eq(news.first.date)
  expect(news_page.items_descriptions.first.text).to eq(news.first.description)
  expect(news_page.footer_secondary.send("#{language_link}")[:href]).to include('page_number')
  expect(news_page.items_titles.size).to eq(10)
end
