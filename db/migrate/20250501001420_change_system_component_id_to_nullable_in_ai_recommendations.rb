class ChangeSystemComponentIdToNullableInAiRecommendations < ActiveRecord::Migration[8.0]
  def change
    change_column_null :ai_recommendations, :system_component_id, true
  end
end
