class UserPromptsController < ApplicationController
  before_action :require_login

  def index
    @user_prompts = current_user.user_prompts.limit(20)
    @user_prompt = UserPrompt.new
  end

  def create
    @user_prompt = current_user.user_prompts.build(user_prompt_params)

    # Get response from OpenAI
    openai_service = OpenaiService.new
    response = openai_service.chat(@user_prompt.content)

    @user_prompt.response = response

    if @user_prompt.save
      redirect_to user_prompts_path, notice: "Your question has been answered!"
    else
      @user_prompts = current_user.user_prompts.limit(20)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def user_prompt_params
    params.require(:user_prompt).permit(:content)
  end
end
