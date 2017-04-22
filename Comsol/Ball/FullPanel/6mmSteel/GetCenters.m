function [x,y,xb,yb] = GetCenters( panel_len, coating_dia )

num_rows = 9;
num_rows_1 = 5;
num_rows_2 = num_rows_1 - 1;
num_cols = 8;
num_cols_1 = 8;
num_cols_2 = num_cols_1 - 1;
row_start_dist_1 = 8.0e-3;
row_start_dist_2 = row_start_dist_1 + 1.05 * coating_dia * sin(pi/3);
col_start_dist_1 = 8.0e-3;
col_start_dist_2 = col_start_dist_1 + coating_dia * sin(pi/6);

row_width_1 = panel_len - 2 * row_start_dist_1;
row_width_2 = panel_len - 2 * row_start_dist_2;
col_width_1 = panel_len - 2 * col_start_dist_1;
col_width_2 = panel_len - 2 * col_start_dist_2;
row_inc_1 = row_width_1 / ( num_rows_1 - 1 );
row_inc_2 = row_width_2 / ( num_rows_2 - 1 );
col_inc_1 = col_width_1 / ( num_cols_1 - 1 );
col_inc_2 = col_width_2 / ( num_cols_2 - 1 );

k = 0;
kb = 0;
r0 = coating_dia/2;
for jj =  1:num_cols_1
  for ii = 1:num_rows_1
    x0 = col_start_dist_1 + (jj-1) * col_inc_1 - panel_len/2;
    y0 = row_start_dist_1 + (ii-1) * row_inc_1 - panel_len/2;
    if(( x0 > 0 ) & ( y0 > 0 ))
      k = k + 1;
      x(k) = x0;
      y(k) = y0;
    else 
      if(( x0 > -r0 ) & ( y0 > -r0 ))
        kb = kb + 1;
        xb(kb) = x0;
        yb(kb) = y0;
      end
    end
  end
end

for jj = 1:num_cols_2
  for ii = 1:num_rows_2
    x0 = col_start_dist_2 + (jj-1) * col_inc_2 - panel_len/2;
    y0 = row_start_dist_2 + (ii-1) * row_inc_2 - panel_len/2;
    if(( x0 > 0 ) & ( y0 > 0 ))
      k = k + 1;
      x(k) = x0;
      y(k) = y0;
    else
      if(( x0 > -r0 ) & ( y0 > -r0 ))
        kb = kb + 1;
        xb(kb) = x0;
        yb(kb) = y0;
      end
    end
  end
end
