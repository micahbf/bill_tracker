class Bill < ActiveRecord::Base
  attr_accessible :description, :owner_id, :total, :decimal_total, :bill_splits_attributes

  validates :owner, :total, :description, presence: true
  validates :total, numericality: { only_integer: true }
  validates :decimal_total, numericality: true, allow_blank: true
  validate :total_greater_than_num_bill_splits
  validate :bill_splits_sum_less_than_total

  belongs_to :owner, class_name: "User"

  has_many :bill_splits, inverse_of: :bill
  accepts_nested_attributes_for :bill_splits

  def decimal_total
    if total
      return Utilities::int_to_decimal(total)
    else
      return nil
    end
  end

  def decimal_total= (decimal)
    self.total = Utilities::decimal_to_int(decimal)
  end

  def bill_split_sum
    bill_splits.map { |bs| bs.amount }.reduce(:+)
  end

  def split_remainder
    total - bill_split_sum
  end

  private

  def total_greater_than_num_bill_splits
    if (total && total <= bill_splits.count)
      errors[:total] << "must be greater than the number of splits"
    end
  end

  def bill_splits_sum_less_than_total
    if (!bill_splits.empty? && bill_split_sum > total)
      errors[:total] << "must be greater than the sum of the splits"
    end
  end
end
