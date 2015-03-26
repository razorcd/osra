require 'rails_helper'

describe "hq/users/index.html.erb", type: :view do

  context 'class action-items' do
    it 'should have a New User link' do
      assign(:users, User.none.paginate(:page => 1))
      render

      expect(rendered).to have_link('New User', new_hq_user_path)
    end
  end

  describe 'should display users correctly with pagination' do
    context 'no users' do
      before(:each) do
        @users = User.none.paginate(:page => 1)
        render
      end

      it 'hides the table' do
        expect(rendered).to match /No Users Found/
        expect(rendered).to have_selector('table#users-index', count: 0)
      end

      it 'hides the pagination bar' do
        expect(rendered).to_not have_selector('.pagination', text: /Previous(.*)1(.*)Next/)
      end
    end

    context '1 user' do
      before(:each) do
        @users = [ FactoryGirl.build_stubbed(:user, 
                   user_name: 'Frederick Bloggs',
                   email: 'fred.bloggs@example.com') ].paginate
        render
      end

      it 'displays a single user' do
        expect(rendered).to have_selector('table tbody tr', count: 1)
        expect(rendered).to have_link('Frederick Bloggs', href: hq_user_path(@users.first))
        expect(rendered).to match 'fred.bloggs@example.com'
      end

      it 'hides the pagination bar' do
        expect(rendered).not_to have_selector('.pagination', text: /Previous(.*)1(.*)Next/)
      end
    end

    context 'many users on multiple pages' do
      before :each do
        @users= [ FactoryGirl.build_stubbed(:user),
                  FactoryGirl.build_stubbed(:user, user_name: 'Joseph Soap',
                    email: 'joe.soap@example.com'),
                  FactoryGirl.build_stubbed(:user, user_name: 'Tom Jones',
                    email: 'tom.jones@example.com') ].paginate(:page => 2, :per_page => 2)
      end

      it 'displays multiple users' do
        render

        expect(rendered).to have_selector('table tbody tr', count: 1)
        expect(rendered).to have_link('Tom Jones', href: hq_user_path(@users.first))
        expect(rendered).to match 'tom.jones@example.com'
        expect(rendered).to_not have_link('Joseph Soap')
        expect(rendered).to_not match 'joe.soap@example.com'
      end

      it 'shoes the pagination bar' do
        render

        expect(rendered).to have_selector('.pagination', text: /Previous(.*)1(.*)Next/)
      end

      it 'paginates' do
        expect(view).to receive(:will_paginate)

        render
      end
    end
  end
end
