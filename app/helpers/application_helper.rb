module ApplicationHelper

  def sortable(column, title = nil, selected_ratings = nil)
    title ||= column.titleize
    css_class =  "#{column}_header"
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction, :ratings =>selected_ratings}, {:id => css_class}
  end
end
                                                                          []