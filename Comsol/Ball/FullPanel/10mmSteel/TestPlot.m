function [x,y] = GetCenters( panel_len, coating_dia )

panel_len = 12.7e-2;
coating_dia = 15.0e-3;

num_rows = 9;
num_rows_1 = 5;
num_rows_2 = num_rows_1 - 1;
num_cols = 8;
num_cols_1 = 8;
num_cols_2 = num_cols_1 - 1;
row_start_dist_1 = 8.0e-3;
row_start_dist_2 = row_start_dist_1 + 1.05 * coating_dia * sin(pi/3)
col_start_dist_1 = 8.0e-3;
col_start_dist_2 = col_start_dist_1 + coating_dia * sin(pi/6)

row_width_1 = panel_len - 2 * row_start_dist_1;
row_width_2 = panel_len - 2 * row_start_dist_2;
col_width_1 = panel_len - 2 * col_start_dist_1;
col_width_2 = panel_len - 2 * col_start_dist_2;
row_inc_1 = row_width_1 / ( num_rows_1 - 1 );
row_inc_2 = row_width_2 / ( num_rows_2 - 1 );
col_inc_1 = col_width_1 / ( num_cols_1 - 1 );
col_inc_2 = col_width_2 / ( num_cols_2 - 1 );


a = 1.05*coating_dia*sin(pi/3)
b = coating_dia*sin(pi/6)
c = row_inc_1 / 2
d = row_inc_2 / 2

k = 0;
for jj =  1:num_cols_1
  for ii = 1:num_rows_1
    k = k + 1;
    x(k) = col_start_dist_1 + (jj-1) * col_inc_1 - panel_len/2;
    y(k) = row_start_dist_1 + (ii-1) * row_inc_1 - panel_len/2;
   end
end
for jj = 1:num_cols_2
  for ii = 1:num_rows_2
    k = k + 1;
    x(k) = col_start_dist_2 + (jj-1) * col_inc_2 - panel_len/2;
    y(k) = row_start_dist_2 + (ii-1) * row_inc_2 - panel_len/2;
  end
end

plot(x,y,'o');
