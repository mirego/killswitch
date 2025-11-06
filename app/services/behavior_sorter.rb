class BehaviorSorter
  def initialize(project)
    @project = project
  end

  # rubocop:disable Naming/PredicateMethod
  def reorder!(behavior_ids)
    @behavior_ids = behavior_ids

    sanitize_behaviors
    reset_all_orders
    reorder_each_behavior

    true
  end
  # rubocop:enable Naming/PredicateMethod

protected

  # Convert the array to a { id1 => 0, id2 => 1 } hash
  def sanitize_behaviors
    @behaviors_map = @behavior_ids.each_with_index.to_a.to_h
  end

  # Apply new order to each behavior using bulk update
  # rubocop:disable Rails/SkipsModelValidations
  def reorder_each_behavior
    return if @behaviors_map.empty?

    # Build a SQL CASE statement for efficient bulk update using Arel to prevent SQL injection
    behavior_order_column = Behavior.arel_table[:behavior_order]
    id_column = Behavior.arel_table[:id]

    case_statement = @behaviors_map.reduce(behavior_order_column) do |stmt, (id, order)|
      Arel::Nodes::Case.new.when(id_column.eq(id.to_i)).then(order).else(stmt)
    end

    @project.behaviors.where(id: @behavior_ids).update_all(behavior_order: case_statement)
  end
  # rubocop:enable Rails/SkipsModelValidations

  # Reset all order keys for the project
  # rubocop:disable Rails/SkipsModelValidations
  def reset_all_orders
    @project.behaviors.update_all behavior_order: 0
  end
  # rubocop:enable Rails/SkipsModelValidations
end
