class MessagesController < ApplicationController


  before_filter :authenticate
  
                            
  def index
    user = User.find(params[:user_id])
    @sent_messages = user.sent_messages
    @received_messages = user.received_messages
    respond_to do |format|
      format.html # index.html.erb
    end
  end


  def show
    @message = Message.find(params[:id])
    if current_user == @message.recipient
      @message.update_attributes(:read=>true)
    end
    respond_to do |format|
      format.html # show.html.erb

    end
  end


  def new
    @message = Message.new
    @recipient_id = params[:recipient_id]
    @subject = params[:subject]
    if @recipient_id == nil
      @users = User.find(:all)
    end
    respond_to do |format|
      format.html # new.html.erb

    end
  end


  def create
    @message = Message.new(params[:message])
    @message.sender_id = current_user.id
    respond_to do |format|
      if @message.save
        flash[:notice] = 'Message was successfully created.'
        # TODO send email notification to recipient
        
        format.html { redirect_to(@message) }

      else
        format.html { render :action => "new" }

    end
    end
    end


  def update
    @message = Message.find(params[:id])
    respond_to do |format|
      if @message.update_attributes(params[:message])
        flash[:notice] = 'Message was successfully updated.'
        format.html { redirect_to(@message) }

      else
        format.html { render :action => "edit" }

      end
    end
  end


  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    respond_to do |format|
      format.html { redirect_to(user_messages_url(current_user)) }

    end
  end
end
