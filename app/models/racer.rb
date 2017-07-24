class Racer

    attr_accessor :id, :number, :first_name, :last_name, :gender, :group, :secs

    def self.mongo_client
        @@db = Mongoid::Clients.default 
    end

    def self.collection
        @@col = self.mongo_client[:racers]
    end

    def self.all(prototype={}, sort={:number=>1}, skip=0, limit=nil)
        if ( limit.nil? == true )
            @@col.find(prototype)
            .sort(sort)
            .skip(skip)
        else
             @@col.find(prototype)
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
        result = (id.is_a? String) ? @@col.find(:_id=>BSON::ObjectId.from_string(id)).first : @@col.find(_id: id).first
        return result.nil? ? nil : Racer.new(result)
    end

    def save
        result = @@col.insert_one(number:@number, first_name:@first_name, last_name:@last_name, gender: @gender, group:@group, secs:@secs)
        @id = @@col.find(number:@number, first_name:@first_name, last_name:@last_name, gender: @gender, group:@group, secs:@secs).first[:_id].to_s
    end

    #
    def update (params)

    end

end
