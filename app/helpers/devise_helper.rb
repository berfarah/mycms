module DeviseHelper
	def devise_error_messages!
		return "" if resource.errors.empty?

		messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg, class: "list-group-item") }.join
		sentence = I18n.t("errors.messages.not_saved",
						  count: resource.errors.count,
						  resource: resource.class.model_name.human.downcase)

		html = <<-HTML
		<div class="panel panel-danger" id="error">
			<div class="panel-heading">
		 		#{sentence}
		 	</div>
		  <ul class="list-group">#{messages}</ul>
		</div>
		HTML

		html.html_safe

	end
end
