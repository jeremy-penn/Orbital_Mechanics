function date_vec = date_after_transfer(print_out, d, m, y, in_h, in_m, in_s, days)
    
    %% calculates the date of arrival after an interplanetary transfer
    %
    % Jeremy Penn
    % 12/11/17
    %
    % function date_after_transfer()
    %
    % Input: o print_out - A string to decide whether to print to screen.
    %                      Leave blank to print-to-screen.
    %
    
    if nargin == 0
        print_out = 'yes';
        
        %% Inputs
        date = input('Input the departure date (dd/mm/yyyy/):\n','s');
        split = strsplit(date, '/');
        
        d = str2double(split{1});
        m = str2double(split{2});
        y = str2double(split{3});
        
        time = input('input the time of departure (HH:MM:SS UT):\n','s');
        split_time = strsplit(time, ':');
        
        in_h = str2double(split_time{1});
        in_m = str2double(split_time{2});
        in_s = str2double(split_time{3});
        
        days = input('Length of transfer (days, use fractions of a day):\n');
    end
    
    %% calculate the new date
    time_h = in_s/3600 + in_m/60 + in_h;
    
    % convert to total days
    if mod(y, 4) == 0
        length_of_month = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    else
        length_of_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    end
    
    month_d = 0;
    for i = 1:m
        month_d = month_d + length_of_month(i);
    end
    
    arrive_d = d + month_d + days + time_h/24; % total days
    
    % back convert to dd/mm/yy from total days
    while arrive_d > 365
        arrive_d = arrive_d - 365;
        y = y + 1;
    end
    
    mm = 0;
    for j = 1:12
        if arrive_d <= length_of_month(j)
            break
        end
        
        arrive_d = arrive_d - length_of_month(j);
        
        mm = mm + 1;
    end
    
    if arrive_d - round(arrive_d) ~= 0
        
        remain = arrive_d - floor(arrive_d);
        arrive_d = floor(arrive_d);
        
        hr = remain * 24;
        
        if hr - round(hr) ~= 0
            
            h_remain = hr - floor(hr);
            hr = floor(hr);
            min = h_remain * 60;
            
            if min - round(min) ~= 0
                
                m_remain = min - floor(min);
                min = floor(min);
                sec = m_remain * 60;
            end
        else
            min = 0;
            sec = 0;
        end
    else
        hr = 0;
        min = 0;
        sec = 0;
    end
    
    date_vec = [y, mm, arrive_d, hr, min, sec];
    
    if strcmp(print_out,'yes')
        date_arrive = datestr(date_vec,'dd/mm/yyyy at HH:MM:SS UT');
        
        da = sprintf('The spacecraft will arrive on %s', date_arrive);
        
        fprintf(da)
        disp(' ')
    end
end