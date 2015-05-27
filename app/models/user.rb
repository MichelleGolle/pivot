class User < ActiveRecord::Base
  has_secure_password
  has_attached_file :picture, styles: {micro: '50x50',
                                       thumb: '100x100',
                                       small: '200x200',
                                       medium: '300x300'
                                     }, default_url: "Handshake_icon.jpg"


  validates_attachment_content_type :picture, content_type: ["image/jpg", "image/jpeg", "image/png"]

  has_many :job_applications, dependent: :destroy
  has_many :jobs
  has_many :business_managers, class_name: "User",
                               foreign_key: "employer_id"

  belongs_to :employer,        class_name: "User"

  validates :name, length: { in: 2..32 }
  validates :username, uniqueness: true, presence: true
  validates :email, presence: true, uniqueness: true,
            format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :location, presence: true
  validates :slug, uniqueness: true

  before_validation :generate_slug

  enum role: %w(applicant business admin business_admin) #Admin = customer service of the site (the highest level of admin). Business = login for owner of the business. business_admin = login for manager of the business
  # Heirarchy: admin => business => business_admin => applicant

  scope :online_businesses, -> { where(business_status: true) }
  scope :offline_businesses, -> { where(business_status: false) }

  before_update :business_status_email?

  def self.find_or_create_by_auth(auth_data)
    user = User.find_or_create_by(id: auth_data['uid'][1..3])
    if user.name != auth_data["info"]["name"]
      user.name     = auth_data["info"]["name"]
      user.username = auth_data["info"]["nickname"]
      user.email    = "temp_email#{auth_data['uid']}@example.com"
      user.password = "temporarypassword"
      user.save
    end
    user
  end

  def generate_slug
    self.slug = username.parameterize
  end

  def date_registered
    created_at.strftime("%A, %d %b %Y %l:%M %p")
  end

  def online?
    business_status == true
  end

  def offline?
    business_status == false
  end

  def show_status
    if business_status == true
      "Online"
    else
      "Offline"
    end
  end

  private

  def business_status_changed?
    UserNotifier.business_status_changed(current_user).deliver_now if business_status_changed?
  end
end
