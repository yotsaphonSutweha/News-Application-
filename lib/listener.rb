class Observer 
    def initialize()
        @observers = []
    end

    def add_observer(observer)
        @observers << observer
    end

    def delete_observer(observer)
        @observers.delete(observer)
    end

    def notify_observers(follower_id, followee_id)
        @observers.each do |observer|
            observer.update(follower_id, followee_id)
        end
    end
end

class Listener < Observer

    def initialize
        super()
    end

    def trigger_following(follower_id, followee_id)
        notify_observers(follower_id, followee_id)
    end
end