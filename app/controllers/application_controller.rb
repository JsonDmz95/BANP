class ApplicationController < ActionController::Base
  # Always run set_lang
  before_action :set_lang
  # End Always run set_lang

  # Domain global variable
  if Rails.env == "development"
    $banp_domain = "http://localhost:3000/"
  else
    $banp_domain = "http://www.betterandnice.com/"
  end
  # End Domain global variable

  # Cookie set language
  def set_lang
    if cookies[:banp_lang] && I18n.available_locales.include?(cookies[:banp_lang].to_sym)
      current_lang = cookies[:banp_lang].to_sym
    else
      current_lang = I18n.default_locale
      cookies.permanent[:banp_lang] = current_lang
    end

    I18n.locale = current_lang
  end
  # End Cookie set language

  # Redirect to back
  def redirect_to_back(state, path, resource, type)
    if state
      if type == "success"
        redirect_back fallback_location: path, notice: t("alerts.enabled", model: t("activerecord.models.#{resource}"))
      elsif type == "error"
        redirect_back fallback_location: path, alert: t("alerts.not_enabled", model: t("activerecord.models.#{resource}"))
      end

    else
      if type == "success"
        redirect_back fallback_location: path, notice: t("alerts.disabled", model: t("activerecord.models.#{resource}"))
      elsif type == "error"
        redirect_back fallback_location: path, alert: t("alerts.not_disabled", model: t("activerecord.models.#{resource}"))
      end
    end
  end

  # Render 404
  def render_404
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end
  # End Render 404

  # Render PDF
  def to_pdf(name_pdf, template, resource, datetime, pdf_title)
    render pdf: name_pdf,
    template: template,
    layout: "admin/application_pdf.html.erb",
    page_size: "letter",
    # orientation: "Landscape", # Portrait
    margin: { top: 10, bottom: 15 },
    footer: { content: render_to_string("layouts/admin/footer_pdf.html.erb", layout: nil, locals: { datetime: datetime }) },
    locals: { resource: resource, pdf_title: pdf_title }
  end
end
