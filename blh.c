#include 	<stdio.h>
#include 	<stdlib.h>
#include	<stddef.h> 
#include 	<math.h>  

void	 	ReadMeshWriteMetrics(); 

int main()
{         
  ReadMeshWriteMetrics();
  return(0);
}

void ReadMeshWriteMetrics()
{
  FILE 		*textfile, *textfile1;
  int 		i, nv, ne, nf, ref, fga, fgh = 1;
  char		prefix[80], data[80], data1[80], element[80];
  double        x, y, h, hmin = 0.001, alpha = 0.2;
  double        xc = 1., yc = 1., rc = 0.5;

            
  printf("prefix file --> ");
  scanf("%s", prefix);
  printf("adaption (0,i) ---> ");
  scanf("%d", &fga);    

  sprintf(data, "%s.0.%d.bl2d", prefix, fga);      
  sprintf(data1, "%s.0.%d.h", prefix, fga);
  printf("********** read mesh -- %s **********\n", data);
  if ((textfile = fopen(data, "r")) == NULL)
  {
    printf("file %s error\n", data);
    exit(0);
  }
  if ((textfile1 = fopen(data1, "w")) == NULL)
  {
    printf("file %s error\n", data1);
    exit(0);
  }
  fscanf(textfile, "%s", element);
  fscanf(textfile, "%d", &nv);  
  fscanf(textfile, "%d", &ne);
  fscanf(textfile, "%d", &nf); 
  fprintf(textfile1, "%d %d\n", nv, fgh); 
  for (i=1; i<=nv; i++) 
  {
    fscanf(textfile, "%lf", &x);
    fscanf(textfile, "%lf", &y); 
    fscanf(textfile, "%d", &ref);
    
    h = hmin + alpha * fabs((x-xc)*(x-xc) + (y-yc)*(y-yc) - rc*rc);
    
    fprintf(textfile1, "%lf\n", h);   
  }     
  fclose(textfile); 
  fclose(textfile1); 
  printf("********** write metrics -- %s **********\n", data1);
}
      
