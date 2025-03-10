Sneakers.configure  :heartbeat => 30,
                     :amqp => "amqp://admin:admin@rabbitmq:5672",
                     :vhost => '/',
                     :exchange => 'sneakers',
                     :exchange_type => :direct,
                     :workers => 4,
                     :prefetch => 10,
                     :ack => true,
                     :timeout_job_after => 5,
                     :durable => true,
                     :threads => 10,
                     :log => STDOUT,
                     :pid_path => "/app/tmp/pids/sneakers.pid"
