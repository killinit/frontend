class NewsDecorator < Draper::CollectionDecorator
  delegate :page

  PAGE_SIZE = 17

  def decorator_class
    NewsArticleDecorator
  end

  def prev_page
    object.page - 1
  end

  def next_page
    object.page + 1
  end

  def next_page?
    object.size == PAGE_SIZE
  end

  def prev_page?
    object.page > 1
  end

  def canonical_url
    h.news_url
  end

  def alternate_options
    I18n.available_locales.each_with_object({}) do |locale, hash|
      hash[locale] = h.news_url(locale)
    end
  end
end