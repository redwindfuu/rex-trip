class AdminsService
  def self.create_admin(params)
    data = {
      id: 1,
      name: "Admin",
      email: "Afmi@g,a.com"
    }
    data
  end

  def self.get_admins
    data = [
      {
        id: 1,
        name: "Admin",
        email: "Afmi@g,a.com"
      },
      {
        id: 2,
        name: "Admin",
        email: "Afmi@g,a.com"
      }
    ]
    data
  end

  def self.get_admin(id)
    data = {
      id: 1,
      name: "Admin",
      email: "Afmi@g,a.com"
    }
    data
  end

  def self.update_admin(id, params)
    data = {
      id: 1,
      name: "Admin",
      email: "Afmi@g,a.com"
    }
    data
  end

  def self.delete_admin(id)
    data = {
      id: 1,
      name: "Admin",
      email: "Afmi@g,a.com"
    }
    data
  end
end
