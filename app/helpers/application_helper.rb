module ApplicationHelper
  include Pagy::Frontend

  def full_title page_title = " "
    base_title = t "text.intern_ruby"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def toastr_flash
    flash_messages = []
    flash.each do |type, message|
      type = "success" if type == "notice"
      type = "error"   if type == "alert"
      text = "<script>toastr.#{type}('#{message}');</script>"
      flash_messages << text if message
    end
    flash_messages.join("\n")
  end
end
