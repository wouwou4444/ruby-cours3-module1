class Racer
    include ActiveModel::Model

    attr_accessor :id, :number, :first_name, :last_name, :gender, :group, :secs

    def persisted?
        !@id.nil?
    end

    def self.mongo_client
        @@db = Mongoid::Clients.default 
    end

    def self.collection
        @@col = self.mongo_client[:racers]
    end

    def self.all(prototype={}, sort={:number=>1}, skip=0, limit=nil)
        if ( limit.nil? == true )
            self.collection.find(prototype)
            .sort(sort)
            .skip(skip)
        else
             self.collection.find(prototype)
            .sort(sort)
            .skip(skip)
            .limit(limit)
        end

    end

    def initialize (params = {})
        @id=params[:_id].nil? ? params[:id] : params[:_id].to_s

        @number=params[:number].to_i

        @first_name=params[:first_name]

        @last_name=params[:last_name]

        @gender=params[:gender]

        @group=params[:group]

        @secs=params[:secs].to_i
    end

    def self.find (id)
        result = (id.is_a? String) ? self.collection.find(:_id=>BSON::ObjectId.from_string(id)).first : self.collection.find(_id: id).first
        return result.nil? ? nil : Racer.new(result)
    end

    def save
        result = Racer.collection.insert_one(number:@number, first_name:@first_name, last_name:@last_name, gender: @gender, group:@group, secs:@secs)
        @id = Racer.collection.find(number:@number, first_name:@first_name, last_name:@last_name, gender: @gender, group:@group, secs:@secs).first[:_id].to_s
    end

    #
    def update (params)
        @number=params[:number].to_i

        @first_name=params[:first_name]

        @last_name=params[:last_name]

        @secs=params[:secs].to_i

        @gender=params[:gender]
        @group=params[:group]

        params.slice!(:number, :first_name, :last_name, :gender, :group, :secs)
        Racer.collection.find(_id:BSON::ObjectId.from_string(@id)).update_one(params)

    end

    def destroy
         Racer.collection.find(:number=>(@number)).delete_one
    end

    def created_at
        nil
    end

    def updated_at
        nil
    end
end
