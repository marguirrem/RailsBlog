class Article < ActiveRecord::Base
	belongs_to :user
	has_many :comments 
	
	has_many :has_categories
	has_many :categories, through: :has_categories

	#Jozy Acevedo
	attr_reader :categories

	validates :title, presence: true, uniqueness: true
	validates :body, presence: true, length:{minimum: 20}
	before_create :set_visits_count
	after_create :save_categories


	has_attached_file :cover,styles: { medium:"1200x720",thumb:"620x480" }
	validates_attachment_content_type :cover,content_type: /\Aimage\/.*\Z/

	def categories=(value)
		@categories = value
	end

	def update_visits_count
		self.update(visits_count: self.visits_count + 1)
	end
	#metodos privados
	private
	def set_visits_count
		self.visits_count =0
	end

	private

	def save_categories
		@categories.each do |category_id|
			HasCategory.create( category_id: category_id,article_id: self.id )
		end
	end
end
