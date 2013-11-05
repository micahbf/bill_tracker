class Bill < ActiveRecord::Base
  attr_accessible :description, :owner_id, :total, :decimal_total

  validates :owner, :total, presence: true
  validate :total_greater_than_num_bill_splits
  validate :bill_splits_sum_less_than_total

  belongs_to :owner, class_name: "User"

  has_many :bill_splits, inverse_of: :bill
  accepts_nested_attributes_for :bill_splits

  def decimal_total
    if total
      return (total / 100).round(2)
    else
      return nil
    end
  end

  def decimal_total= (decimal)
    total = (decimal * 100).floor
  end

  private

  def total_greater_than_num_bill_splits
    if (total && total <= bill_splits.count)
      errors[:total] << "must be greater than the number of splits"
    end
  end

  def bill_splits_sum_less_than_total
    if (!bill_splits.empty? && bill_splits.sum(:amount) > total)
      errors[:total] << "must be greater than the sum of the splits"
    end
  end
end
