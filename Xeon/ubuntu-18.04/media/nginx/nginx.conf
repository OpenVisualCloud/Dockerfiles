
worker_processes auto;
worker_rlimit_nofile 8192;
daemon off;

events {
    worker_connections  4096;
}

rtmp {
    server {
        listen 1935;
        chunk_size 4000;

        application stream {
            live on;
        }

        application hls {
            live on;
            hls on;
            hls_path /var/www/hls;
            hls_nested on;
            hls_fragment 3;
            hls_playlist_length 60;
        }

        application dash {
            live on;
            dash on;
            dash_path /var/www/dash;
            dash_fragment 3;
            dash_playlist_length 60;
            dash_nested on;
        }
    }
}

http {
    include mime.types;
    default_type application/octet-stream;
    directio 512;
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    aio on;

    ssl_ciphers HIGH:!aNULL:!MD5; 
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    proxy_cache_path /var/www/cache levels=1:2 keys_zone=one:10m use_temp_path=off;

    server {
        listen 80;
        #server_name  localhost;
        client_max_body_size 1024M;

        # proxy cache settings
        proxy_cache one;
        proxy_no_cache $http_pragma $http_authorization;
        proxy_cache_bypass $cookie_nocache $arg_nocache$arg_comment;
        proxy_cache_valid 200 302 10m;
        proxy_cache_valid 303 1m;

        location / {
            root /var/www/html;
            add_header 'Access-Control-Allow-Origin' '*' always;
            add_header 'Access-Control-Expose-Headers' 'Content-Length';
        }

        location /hls {
            alias /var/www/hls;
            add_header Cache-Control no-cache;
            add_header 'Access-Control-Allow-Origin' '*' always;
            add_header 'Access-Control-Expose-Headers' 'Content-Length';
            types {
                application/vnd.apple.mpegurl m3u8;
                video/mp2t ts;
            }
        }

        location /dash {
            alias /var/www/dash;
            add_header Cache-Control no-cache;
            add_header 'Access-Control-Allow-Origin' '*' always;
            add_header 'Access-Control-Expose-Headers' 'Content-Length';
            types {
                application/dash+xml mpd;
            }
        }

        location /stat {
            rtmp_stat all;
            rtmp_stat_stylesheet stat.xsl;
        }

        location /upload {

            # Pass altered request body to this location
            upload_pass @backend;
            upload_pass_args on;

            # Store files to this directory
            upload_store /var/nginx/html/upload;  

            # Allow uploaded files to be read/write only by group
            upload_store_access group:rw;

            # Set specified fields in request body
            upload_set_form_field $upload_field_name.name "$upload_file_name";
            upload_set_form_field $upload_field_name.content_type "$upload_content_type";
            upload_set_form_field $upload_field_name.path "$upload_tmp_path";

            # Inform backend about hash and size of a file
            upload_aggregate_form_field "$upload_field_name.md5" "$upload_file_md5";
            upload_aggregate_form_field "$upload_field_name.size" "$upload_file_size";

            #upload_pass_form_field "^submit$|^description$";
            upload_pass_form_field "office";
            upload_pass_form_field "sensor";
            upload_pass_form_field "dirname";

            upload_cleanup 400 404 499 500-505;
        }

        # Pass altered request body to a backend
        location @backend {
           proxy_pass   http://localhost:8080;
        }
    }
}

