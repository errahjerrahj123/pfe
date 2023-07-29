class ProspectSubscription < ApplicationRecord
  belongs_to :course
  belongs_to :batch
end