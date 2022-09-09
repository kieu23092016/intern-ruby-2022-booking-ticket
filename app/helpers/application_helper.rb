module ApplicationHelper
  include Pagy::Frontend

  def full_title page_title = " "
    base_title = t "text.intern_ruby"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end
end
