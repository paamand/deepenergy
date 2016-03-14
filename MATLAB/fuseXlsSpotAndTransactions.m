y = '2015';
for m={'01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12'}
	m=m{:};
    ['intraday_transactions_germany_austria_' y '-' m '.xlsx']
    [DATE_VOL_PRICE_TIME, MARKET_AND_HOUR] = xlsread(['intraday_transactions_germany_austria_' y '-' m '.xlsx']);
        DATE_VOL_PRICE_TIME(1:2,:)=[];
        DATE_VOL_PRICE_TIME(:,2:5)=[];
        MARKET_AND_HOUR(1:2,:)=[];
        MARKET_AND_HOUR(:,[1 6:9])=[];
    SPOT.prices = xlsread(['auction_spot_germany_austria_' y '.xlsx'],'Prices');
    SPOT.volumes = xlsread(['auction_spot_germany_austria_' y '.xlsx'],'Volumes');
        SPOT.prices(1:2,:)=[];
        SPOT.prices(:,[5 27:end])=[];
        SPOT.volumes(1:2,:)=[];
        SPOT.volumes(:,[5 27:end])=[];

    SPOT.volumes(str2num(datestr(x2mdate(SPOT.prices(:,1)),'mm')) ~= str2num(m),:)=[];
    SPOT.prices(str2num(datestr(x2mdate(SPOT.prices(:,1)),'mm')) ~= str2num(m),:)=[];

    l = size(DATE_VOL_PRICE_TIME,1);
    DATE_VOL_PRICE_TIME = [DATE_VOL_PRICE_TIME; NaN(size(SPOT.prices,1),4)];
    MARKET_AND_HOUR = [MARKET_AND_HOUR; cell(size(SPOT.prices,1),4)];
    for i=1:size(SPOT.prices,1)
        for h=1:24
            % Append the spot price to the price matrix at 12:45hrs.
            DATE_VOL_PRICE_TIME(l+(i-1)*24+h,:)=[SPOT.prices(i,1) SPOT.volumes(i,h+1) SPOT.prices(i,h+1) m2xdate(x2mdate(SPOT.prices(i,1))-0.5+3/4/24)];
            MARKET_AND_HOUR(l+(i-1)*24+h,:)={'DE' 'DE' num2str(h) num2str(h)};
        end
    end

    save(['SpotAndTransactions_' y '-' m],'DATE_VOL_PRICE_TIME','MARKET_AND_HOUR');
    clearvars -except m y;
end