require "rails_helper"

RSpec.describe User, :type => :model do
  describe '#format_attributes' do
    context 'common name' do
      let (:unformat_first_name) { 'bob' }
      let (:unformat_last_name) { 'hope' }
      let (:unformat_email) { 'TEST@gmail.com'}

      before do
        create(
          :user,
          email: unformat_email,
          first_name: unformat_first_name,
          last_name: unformat_last_name
        )
      end

      it 'downcase email on save' do
        expect(described_class.last.email).to eq(unformat_email.downcase)
      end

      it 'titleize the first_name' do
        expect(described_class.last.first_name).to eq(unformat_first_name.capitalize)
      end

      it 'titleize the last_name' do
        expect(described_class.last.last_name).to eq(unformat_last_name.capitalize)
      end
    end
  end

  context 'hypen in name' do
    it 'saves the hyphen and titleize' do
      user = create(:user, last_name: 'bob-hudson')
      expect(user.last_name).to eq('Bob-Hudson')
    end
  end

  context 'apostrophe in name' do
    it 'saves the apostrophe and titleize' do
      user = create(:user, last_name: "o'reily")
      expect(user.last_name).to eq("O'Reily")
    end
  end

  context 'period in name' do
    it 'saves the period and titleize' do
      user = create(:user, last_name: "mr.big")
      expect(user.last_name).to eq("Mr.Big")
    end
  end
end
