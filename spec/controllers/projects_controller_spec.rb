require 'spec_helper'

describe ProjectsController do
  before do
    controller.stub(:authorize!).and_return(true)
    controller.stub(:authenticate_user!).and_return(true)
    controller.stub(:current_user).and_return(build_stubbed :user)
  end

  describe "GET show" do
    it "assigns @project" do
      project = build_stubbed :project_approved
      Project.stub(:find).and_return(project)

      get :show, {id: project.to_param}

      expect(assigns(:project)).to eq(project)
    end

    it "assigns @charity" do
      project = build_stubbed :project_approved
      Project.stub(:find).and_return(project)

      get :show, {id: project.to_param}

      expect(assigns(:charity)).to eq(project.charity)
    end
  end

  describe "POST create" do
    it "assigns @project" do
      charity = create :charity_approved, leader: controller.current_user
      project = project_required_attributes

      post :create, {charity_id: charity.to_param, project: project}

      expect(assigns(:project)).to be_a Project
      expect(assigns(:project)).to be_persisted
    end

    it "assigns @charity" do
      charity = create :charity_approved, leader: controller.current_user

      post :create, {charity_id: charity.to_param, project: {}}

      expect(assigns(:charity)).to eq charity
    end

    it "adds a project with a new sub-cause" do
      charity = create :charity_approved, leader: controller.current_user
      project = project_required_attributes
      project = project.merge sub_cause_attributes('sub_cause_1')

      SubCause.should_receive(:new)

      post :create, {charity_id: charity.to_param, project: project}
    end

    it "adds a project with an existing sub-cause" do
      charity = create :charity_approved, leader: controller.current_user
      sub_cause_name = 'sub_cause_1'
      project = project_required_attributes
      project = project.merge sub_cause_attributes(sub_cause_name)
      create :sub_cause, name: sub_cause_name, cause: Cause.first

      SubCause.should_not_receive(:new)

      post :create, {charity_id: charity.to_param, project: project}
    end

    it 'adds a project with a faq comprised of question and answer' do
      charity = create :charity_approved, leader: controller.current_user
      project = project_required_attributes
      project = project.merge faqs_attributes

      question = double('Comment')
      faq = double('Faq', question: question)
      Faq.stub(:find_or_create_by_id_and_project_id).and_return(faq)
      Faq.should_receive(:find_or_create_by_id_and_project_id)
      faq.should_receive(:comments=)
      question.should_receive(:comments=)

      post :create, {charity_id: charity.to_param, project: project}
    end

    it 'adds a project with a faq comprised of question and no answer' do
      charity = create :charity_approved, leader: controller.current_user
      project = project_required_attributes
      project = project.merge faqs_attributes(true, false)

      question = double('Comment')
      faq = double('Faq', question: question)
      Faq.stub(:find_or_create_by_id_and_project_id).and_return(faq)
      Faq.should_receive(:find_or_create_by_id_and_project_id)
      faq.should_receive(:comments=)
      question.should_not_receive(:comments=)

      post :create, {charity_id: charity.to_param, project: project}
    end

    it 'adds a project without a faq when there is no question' do
      charity = create :charity_approved, leader: controller.current_user
      project = project_required_attributes
      project = project.merge faqs_attributes(false)

      Faq.should_not_receive(:find_or_create_by_id_and_project_id)

      post :create, {charity_id: charity.to_param, project: project}
    end

    it 'adds a project with the current user as leader' do
      charity = create :charity_approved, leader: controller.current_user
      project = project_required_attributes

      post :create, {charity_id: charity.to_param, project: project}

      expect(assigns(:project).leader).to eq controller.current_user
    end
  end

  describe "PUT update" do
    it "assigns @project" do
      charity = create :charity_approved
      project = create :project, charity: charity

      put :update, {charity_id: charity.to_param, id: project.id, project: {}}

      expect(assigns(:project).id).to eq project.id
    end

    it "assigns @charity" do
      charity = create :charity_approved
      project = create :project, charity: charity

      put :update, {charity_id: charity.to_param, id: project.id, project: {}}

      expect(assigns(:charity).id).to eq charity.id
    end

    it "updates a project with a new sub-cause" do
      pending "Building sub causes isn't working in this environment, don't know why"
      charity = create :charity_approved
      project = create :project, charity: charity

      SubCause.should_receive(:new)

      cause_id = Cause.first.id
      sub_causes = { cause_sub_causes: { cause_id.to_s => { 'sub_cause_list'=> 'sub_cause' } } }
      attributes = sub_causes.merge({ cause_ids: [cause_id] })
      put :update, {charity_id: charity.to_param, id: project.id, project: attributes }
    end

    it "updates a project with an existing sub-cause" do
      charity = create :charity_approved
      project = create :project, charity: charity
      sub_cause_name = 'sub_cause_1'
      cause = Cause.first
      create :sub_cause, name: sub_cause_name, cause: cause

      SubCause.should_not_receive(:new)

      sub_causes = { cause_sub_causes: { cause.id.to_s => { 'sub_cause_list'=> sub_cause_name } } }
      attributes = sub_causes.merge({ cause_ids: [cause.id] })
      put :update, {charity_id: charity.to_param, id: project.id, project: attributes }
    end

    it 'updates a project with a new faq' do
      charity = build_stubbed :charity

      project = double 'Project', id: 1
      project.stub(:update_attributes!)
      project.stub(:save!)
      project.stub(:sub_causes=)
      project.stub(:help_image)
      project.stub(:draft)
      project.stub_chain(:sub_causes, :build)
      project.stub(:find).and_return(project)
      charity = double 'Charity', projects: project
      Charity.stub(:find).and_return(charity)
      ProjectMailer.stub_chain(:submit_project_to_requester, :deliver)
      ProjectMailer.stub_chain(:submit_project_to_charity_master_admin, :deliver)

      question = double('Comment')
      faq = double('Faq', question: question)
      Faq.stub(:find_or_create_by_id_and_project_id).and_return(faq)
      Faq.should_receive(:find_or_create_by_id_and_project_id)
      faq.should_receive(:comments=)
      question.should_receive(:comments=)

      post :update, {charity_id: charity.to_param, id: project.id, project: faqs_attributes}
    end

    it 'sends an email to the project owner if the project was successfully submitted' do
      project = create :project_ready_for_approval
      charity = project.charity

      ProjectMailer.should_receive(:submit_project_to_requester).with(an_instance_of(Project)).and_call_original

      post :update, {charity_id: charity.to_param, id: project.id, project: {draft: false}}

      expect(ActionMailer::Base.deliveries[-2].to).to include project.leader.email
    end

    it 'sends an email to the charity master admin if the project was successfully submitted' do
      project = create :project_ready_for_approval
      charity = project.charity

      ProjectMailer.should_receive(:submit_project_to_charity_master_admin).with(an_instance_of(Project)).and_call_original

      post :update, {charity_id: charity.to_param, id: project.id, project: {draft: false}}

      expect(ActionMailer::Base.deliveries.last.to).to include ENV['CHARITY_MASTER_ADMIN_EMAIL']
    end
  end

  describe "DELETE destroy" do
    it "assigns @project" do
      project = double Project
      project.stub(:destroy).and_return(true)
      Project.stub(:find) { project }

      delete :destroy, {id: '1'}

      expect(assigns(:project)).to eq(project)
    end
  end
end

private

def project_required_attributes
  project = attributes_for :project_without_charity
  projects_makes_attributes = { 'projects_makes_attributes' => { '1' => { 'make_id' => create(:make).id, 'cost' => 1 } } }
  projects_changes_attributes = { 'projects_changes_attributes' => { '1' => { 'change_id' => create(:change).id, 'number' => 1 } } }
  cause = create(:cause)
  cause_ids = { 'cause_ids' => [cause.id] }

  project.merge(projects_makes_attributes).merge(projects_changes_attributes).merge(cause_ids)
end

def sub_cause_attributes(sub_causes)
  return unless sub_causes.present?

  cause = Cause.first || create(:cause)
  { cause_sub_causes: { cause.id.to_s => { 'sub_cause_list' => sub_causes } } }
end

def faqs_attributes(has_question = true, has_answer = true)
  question = has_question ? 'Some question' : ''
  answer = has_answer ? 'Some answer' : ''
  { faqs_attributes: { '0' => { question: question, answer: answer } } }
end
