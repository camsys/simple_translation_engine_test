module ApplicationHelper

  # Converts alert type to appropriate bootstrap class
  def map_alert(type)
    alert_mappings = {
      notice: "success",
      alert: "warning"
    }
    alert_mappings[type.to_sym] || type.to_s
  end
  
end
