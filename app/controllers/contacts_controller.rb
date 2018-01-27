class ContactsController < ApplicationController
  def index
    @contacts = Contact.all

    search_term = params[:search]
    if search_term
      @contacts = @contacts.where("first_name iLIKE ? OR last_name iLIKE ?", 
                                  "%#{search_term}%",
                                  "%#{search_term}%")
    end
    
    sort_attribute = params[:sort]
    if sort_attribute
      @contacts = @contacts.order(sort_attribute => :asc)
    end

    render 'index.json.jbuilder'
  end

  def create
    @contact = Contact.new(
                          first_name: params[:first_name],
                          middle_name: params[:middle_name],
                          last_name: params[:last_name],
                          email: params[:email],
                          phone_number: params[:phone_number],
                          bio: params[:bio]
                          )
    if @contact.save
    render 'show.json.jbuilder'
    else 
      render json: {errors: @contact.errors.full_messages}, status: :unprocessable_entity 
    end
  end

  def show
    @contact = Contact.find(params[:id])
    render 'show.json.jbuilder'
  end

  def update
    @contact = Contact.find(params[:id])
    
    @contact.first_name = params[:first_name] || @contact.first_name
    @contact.middle_name = params[:middle_name] || @contact.middle_name
    @contact.last_name = params[:last_name] || @contact.last_name
    @contact.email = params[:email] || @contact.email
    @contact.phone_number = params[:phone_number] || @contact.phone_number
    @contact.bio = params[:bio] || @contact.bio
    
    if
      @contact.save
      render json: 'show.json.jbuilder'
    else
      render json: {message: @contact.errors.full_messages}, status: :unprocessable_entity
    end
  end

 def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    render json: {message: "Successfully destroyed @contact ##{@contact.id}"}
  end
end
