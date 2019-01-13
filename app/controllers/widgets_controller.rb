class WidgetsController < ApplicationController

  def list_widgets
    widgets = Widget.all
    response = {}
    widgets.each do |widget|
      response[widget.id] = widget.msrp
    end
    render json: response
  end

end
