class BehaviorSorter
  def initialize(project)
    @project = project
  end

  def reorder!(behavior_ids)
    @behavior_ids = behavior_ids

    sanitize_behaviors
    reset_all_orders
    reorder_each_behavior

    true
  end

protected

  # Convert the array to a { id1 => 0, id2 => 1 } hash
  def sanitize_behaviors
    @behaviors_map = Hash[@behavior_ids.each_with_index.to_a]
  end

  # Apply new order to each behavior
  def reorder_each_behavior
    behaviors = @project.behaviors.where(id: @behavior_ids)
    behaviors.each do |behavior|
      behavior.update behavior_order: @behaviors_map[behavior.id.to_s]
    end
  end

  # Reset all order keys for the project
  def reset_all_orders
    @project.behaviors.update_all behavior_order: 0
  end
end
